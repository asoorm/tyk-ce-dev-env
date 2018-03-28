#!/bin/bash

up() {
    cp ./example.apis/04_lwan_keyless.json ./gateway-data/apps/04_lwan_keyless.json
    docker-compose -f docker-compose.bench.yaml -f docker-compose.yaml up -d > /dev/null 2>&1
}

down() {
    rm ./gateway-data/apps/04_lwan_keyless.json
    docker-compose -f docker-compose.bench.yaml -f docker-compose.yaml down > /dev/null 2>&1
}

# $1 num requests
# $2 concurrency
# $3 url
hey() {
    docker run --rm -it --network tykce_tyk-ce rcmorano/docker-hey -n $1 -c $2 $3
}

# $1 url
bench() {
    up

    echo "Base: $1"
    hey 10000 50 $1

    down
}

bench 'http://lwan:8080/json.json'
bench 'http://gateway:8080/lwan-keyless/json.json'
