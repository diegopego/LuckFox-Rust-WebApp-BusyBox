use std::env;
use std::path::PathBuf;

fn main() {
    // Tell cargo to tell rustc to link the system sqlite3
    println!("cargo:rustc-link-lib=static=sqlite3");

    // Tell cargo to invalidate the built crate whenever the wrapper changes
    println!("cargo:rerun-if-changed=wrapper.h");

    // The directory containing the precompiled library
    let lib_dir = PathBuf::from("/workspace");

    // Add the directory to the linker search path
    println!("cargo:rustc-link-search=native={}", lib_dir.display());

    // Tell rustc to use the correct include path for SQLite
    let include_dir = PathBuf::from("/workspace");
    println!("cargo:include={}", include_dir.display());
}
