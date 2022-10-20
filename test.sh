#!/bin/bash

set -o errexit

podman build -t minimal_arm_rust_test:latest .
podman run -it minimal_arm_rust_test:latest
