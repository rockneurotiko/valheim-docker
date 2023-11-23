#!/bin/bash

docker build --target=main -f Dockerfile -t rockneurotiko/valheim:latest .
docker build --target=plus -f Dockerfile -t rockneurotiko/valheim:plus .
