use actix_web::{web, App, HttpServer, Responder, HttpResponse};
use rusqlite::{params, Connection};
use std::sync::Mutex;
use std::env;
use serde::Serialize;

#[derive(Debug, Serialize)]
struct Person {
    id: i32,
    name: String,
    data: Vec<u8>,
}

struct AppState {
    conn: Mutex<Connection>,
}

async fn greet() -> impl Responder {
    format!("Hello World!")
}
async fn get_persons(data: web::Data<AppState>) -> impl Responder {
    let persons_result = {
        let conn = data.conn.lock().unwrap();
        let mut stmt = match conn.prepare("SELECT id, name, data FROM person") {
            Ok(stmt) => stmt,
            Err(_) => return HttpResponse::InternalServerError().body("Failed to prepare statement"),
        };

        let person_iter = match stmt.query_map([], |row| {
            Ok(Person {
                id: row.get(0)?,
                name: row.get(1)?,
                data: row.get(2)?,
            })
        }) {
            Ok(iter) => iter,
            Err(_) => return HttpResponse::InternalServerError().body("Failed to query"),
        };

        let mut persons = Vec::new();
        for person in person_iter {
            match person {
                Ok(p) => persons.push(p),
                Err(_) => return HttpResponse::InternalServerError().body("Failed to collect persons"),
            }
        }
        persons
    };

    HttpResponse::Ok().json(persons_result)
}

async fn add_person(data: web::Data<AppState>) -> impl Responder {
    let result = {
        let conn = data.conn.lock().unwrap();
        conn.execute(
            "INSERT INTO person (name, data) VALUES (?1, ?2)",
            params!["Alice", &vec![1u8, 2, 3, 4] as &[u8]],
        )
    };

    match result {
        Ok(_) => HttpResponse::Ok().body("Person added"),
        Err(_) => HttpResponse::InternalServerError().body("Failed to insert person"),
    }
}


#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env::set_var("RUST_LOG", "debug");
    env_logger::init();

    let conn = Connection::open("test.db").expect("Failed to open database");

    conn.execute(
        "CREATE TABLE IF NOT EXISTS person (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            data BLOB
        )",
        [],
    ).expect("Failed to create table");

    let app_state = web::Data::new(AppState {
        conn: Mutex::new(conn),
    });

    println!("Starting HTTP server");

    HttpServer::new(move || {
        println!("Configuring App");
        App::new()
            .app_data(app_state.clone())
            .route("/", web::get().to(greet))
            .route("/add_person", web::post().to(add_person))
            .route("/get_persons", web::get().to(get_persons))
    })
        .bind("0.0.0.0:8080")?
        .run()
        .await
}
