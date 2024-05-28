#!/bin/bash

set -e

# Download SQLite source code
wget https://sqlite.org/2024/sqlite-autoconf-3460000.tar.gz
tar xvf sqlite-autoconf-3460000.tar.gz
cd sqlite-autoconf-3460000

# Set up cross-compilation environment
export CC=arm-linux-gnueabihf-gcc

# Configure SQLite for ARMv7 without libtool
./configure --host=arm-linux-gnueabihf --disable-shared --enable-static \
    CFLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_OMIT_JSON1 -DSQLITE_OMIT_RTREE -DSQLITE_OMIT_FTS3 -static" \
    LDFLAGS="-static -lpthread -ldl"

# Clean previous builds
make clean

make -j12

# Compile SQLite manually to ensure static linking
$CC -o sqlite3 -static shell.c sqlite3.c -lm -lpthread -ldl

# Verify the binary architecture
file sqlite3

# Copy the compiled binary to the workspace directory
cp sqlite3 /workspace/sqlite3
cp .libs/libsqlite3.a /workspace/libsqlite3.a
