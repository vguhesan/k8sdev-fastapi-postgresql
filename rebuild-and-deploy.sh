#!/usr/bin/env bash

# Script leveraged by watchman to rebuild and deploy the FastAPI Python app

podman-compose down
podman-compose build
podman-compose -f compose.yaml up -d
