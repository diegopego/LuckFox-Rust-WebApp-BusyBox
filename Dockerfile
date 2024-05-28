FROM rustembedded/cross:armv7-unknown-linux-gnueabihf-0.2.1

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    build-essential \
    gcc-arm-linux-gnueabihf \
    make \
    file  \
    libssl-dev \
    pkg-config

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH

# Install Rust target for ARMv7
RUN rustup target add armv7-unknown-linux-gnueabihf


WORKDIR /workspace
