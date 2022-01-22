Bilygine is a small project based on Google AI services which allows you to search words in videos.

# Prerequisites

To start the full Bilygine Stack, you need a UNIX environment with JAVA 8+, docker 17+, and docker-compose 1.13+

# Architecture
![](https://gyazo.com/9c3f8d0a78f1d5b0e67f0faec3d89507.png)

# UI Examples
## Add new sources
![](https://gyazo.com/ca6c66f566b98f16c75610e759fa3b96.png)

## Research by occurences
![](https://gyazo.com/dc6c12f8754585b2e854abada7987287.png)
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
