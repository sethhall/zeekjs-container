#!/bin/sh

docker buildx build --platform linux/x86_64,linux/aarch64 --push -t ghcr.io/sethhall/zeekjs:latest .
