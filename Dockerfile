# Use the official Rust base image
FROM rust:1-bookworm

# Install Git
RUN apt-get update && apt-get install -y git

# Rustup set stable and update
RUN rustup override set stable && rustup update

ENV HOME="/home"

# Install Cairo
RUN curl -L https://github.com/franalgaba/cairo-installer/raw/main/bin/cairo-installer | bash
ENV PATH="$HOME/.cairo/target/release:$PATH"

RUN mkdir "$HOME/.scarb/"
RUN curl -#L https://github.com/software-mansion/scarb/releases/download/v0.4.0/scarb-v0.4.0-aarch64-unknown-linux-gnu.tar.gz | tar -xzC "/home"
RUN mv /home/scarb-v0.4.0-aarch64-unknown-linux-gnu /home/.scarb
ENV PATH="$HOME/.scarb:$PATH"

# Copy Dojoengine bins (compiled for linux arch)
COPY ./dojo-bins /home/.dojo/bin/
ENV PATH="/home/.dojo/bin:$PATH"

# Create a new directory for the application
WORKDIR /project

# Build the Rust application
# RUN cargo build --release

# Set the entry point for the container
CMD ["bash"]
