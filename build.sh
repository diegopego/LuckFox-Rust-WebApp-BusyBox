#!/bin/bash

set -e

# Set the environment variables for static linking
export SQLITE3_LIB_DIR="/workspace"
export SQLITE3_INCLUDE_DIR="/workspace"
export PKG_CONFIG_PATH="/workspace"
export PKG_CONFIG_ALLOW_CROSS=1
export CC=arm-linux-gnueabihf-gcc
export AR=arm-linux-gnueabihf-ar
export CXX=arm-linux-gnueabihf-g++
export LINKER=arm-linux-gnueabihf-ld
export CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_LINKER=arm-linux-gnueabihf-gcc
export RUSTFLAGS="-C target-feature=+crt-static -C link-args=-lpthread -C link-args=-ldl"

# Build the Rust application for ARMv7 in release mode using cross
cargo build --target armv7-unknown-linux-musleabihf --release

# Verify the binary architecture
file target/armv7-unknown-linux-musleabihf/release/LuckFox

# Copy the compiled binary to the workspace directory
cp target/armv7-unknown-linux-musleabihf/release/LuckFox LuckFox

# Reset the environment variables
unset SQLITE3_LIB_DIR
unset SQLITE3_INCLUDE_DIR
unset PKG_CONFIG_PATH
unset CC
unset CXX
unset AR
unset CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_LINKER
unset RUSTFLAGS
