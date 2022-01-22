# Prerequisites

To start the full Bilygine Stack, you need a UNIX environment with JAVA 8+, docker 17+, and docker-compose 1.13+

# How to start the bilygine stack

## Install
    ./install.sh
Then, copy your google credentials into 'credentials' folder

## Start Bilygine Stack
    ./bilygine.sh

## Start only select services
    ./bilygine.sh <service_1> <service_2> ...

## Start monitoring Stack
    ./bilygine.sh -m

## Detach mode
    ./bilygine.sh -d

## Kill a service
    ./bilygine.sh -k <service_name>

## Remove the whole Stack
    ./bilygine.sh -D

## Start the stack in production mode
    ./bilygine.sh -p
