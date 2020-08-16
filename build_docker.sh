#!/bin/bash

(cd pd && docker build -t ipd .)

(cd tidb && docker build -t itidb .)

# too slow!!!
(cd tikv && DOCKER_IMAGE_NAME=itikv make docker)

