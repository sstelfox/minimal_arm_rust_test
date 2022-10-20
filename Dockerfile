FROM docker.io/library/rust:1.64 AS build

WORKDIR /usr/src

RUN apt-get update && apt-get install musl-tools -y
RUN rustup target add x86_64-unknown-linux-musl

RUN USER=root cargo new minimal_arm_rust_test
WORKDIR /usr/src/minimal_arm_rust_test

COPY Cargo.toml Cargo.lock ./
RUN cargo build --release

COPY src ./src
RUN cargo install --target x86_64-unknown-linux-musl --path .

FROM alpine:latest

RUN apk add --no-cache tini
COPY --from=build /usr/local/cargo/bin/minimal_arm_rust_test /usr/sbin/minimal_arm_rust_test

ENV RUST_LOG "info"

USER 1000

ENTRYPOINT ["/sbin/tini"]

CMD ["/usr/sbin/minimal_arm_rust_test"]
