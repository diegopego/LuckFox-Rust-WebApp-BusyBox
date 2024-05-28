FROM rustembedded/cross:armv7-unknown-linux-gnueabihf-0.2.1

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    build-essential \
    gcc-arm-linux-gnueabihf \
    make \
    file  \
    sed \
    libssl-dev \
    pkg-config

RUN ln -s /bin/sed /usr/bin/sed

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH

# Install Rust target for ARMv7
RUN rustup target add armv7-unknown-linux-gnueabihf
RUN rustup target add armv7-unknown-linux-musleabihf

WORKDIR /workspace