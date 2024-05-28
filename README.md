# Rust Web App on LuckFox Pico (Busybox)

I've only tested this on the **Luckfox Pico Pro**, but specifically designed for the default Busybox image by LuckFox.

* **Binary Size**: 9.9MB DISK
* **Idle Memory**: 17MB RAM
* **Max Load Memory**: 24MB RAM

* **Hello World** - 4,350 requests per second
* **SQLite SELECT Query** - 1,010 requests per second
* **SQLite INSERT Query** - 169 requests per second

## Building

    docker compose up -d
    docker compose exec cross-compile /bin/bash
    ./compile_sqlite.sh
    ./build.sh

You be left with `LuckFox` binary file:

    target/armv7-unknown-linux-musleabihf/release/LuckFox: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), 
    statically linked, BuildID[sha1]=f8474cdfa499a012787676035af9fd52216c00ba, not stripped

Upload this to your LuckFox Pico.


## Benchmarks

Hello World - 4,350 requests per second

`wrk -t12 -c400 -d30s http://192.168.3.109:8080/`

    Running 30s test @ http://192.168.3.109:8080/
    12 threads and 400 connections
    Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    91.29ms   19.18ms 324.94ms   96.78%
    Req/Sec   365.08     37.96   616.00     82.12%
    130931 requests in 30.10s, 16.11MB read
    Requests/sec:   4350.16
    Transfer/sec:    548.02KB

SQLite SELECT Query - 1,010 requests per second

`wrk -t12 -c400 -d30s http://192.168.3.109:8080/get_persons`

    Running 30s test @ http://192.168.3.109:8080/get_persons
    12 threads and 400 connections
    Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   388.91ms   36.32ms 850.52ms   93.82%
    Req/Sec    89.03     63.31   323.00     69.17%
    30388 requests in 30.05s, 4.35MB read
    Requests/sec:   1011.40
    Transfer/sec:    148.15KB

SQLite INSERT Query - 169 requests per second

`wrk -t12 -c400 -d30s -s /mnt/c/Users/xingo/RustroverProjects/LuckFox/post.lua http://192.168.3.109:8080/add_person`

    Running 30s test @ http://192.168.3.109:8080/add_person
    12 threads and 400 connections
    Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.16s   479.64ms   2.00s    73.98%
    Req/Sec    49.87     51.69   181.00     84.21%
    5114 requests in 30.10s, 439.48KB read
    Socket errors: connect 0, read 3, write 0, timeout 4553
    Requests/sec:    169.91
    Transfer/sec:     14.60KB