FROM docker.io/library/rust:1.64 AS build

WORKDIR /usr/src

RUN USER=root cargo new minimal_arm_rust_test
WORKDIR /usr/src/minimal_arm_rust_test

COPY Cargo.toml Cargo.lock ./
RUN cargo build --release

COPY src ./src
RUN cargo install --path .

FROM scratch

COPY --from=build /usr/local/cargo/bin/minimal_arm_rust_test /minimal_arm_rust_test

ENV RUST_LOG "info"

USER 1000

ENTRYPOINT ["/usr/sbin/minimal_arm_rust_test"]
