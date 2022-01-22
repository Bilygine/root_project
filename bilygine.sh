#!/bin/bash

services=(mediator db analyzer api bridge console sentiment traefik)

command="docker-compose -f docker-compose.yml"
order="up"

show_help() {
    echo -e "\n Usage:"
    echo -e "\t/bilygine.sh [-hdrmkD] [service1] [service2]...[serviceN]"
    echo -e "\n\t-h : Display this help"
    echo -e "\t-d : Execute docker-compose in detach mode"
    echo -e "\t-k : Kill services"
    echo -e "\t-r : Restart the stack or the services provided"
    echo -e "\t-m : Start the Monitoring stack in addition to services provided. If provided with no specific services, start the whole stack"
    echo -e "\t-D : Down the stack (docker-compose down)"
    echo -e "\t-p : Start the stack in production mode"

    echo -e "\n List of possible services :"
    for i in  ${services[@]}
    do
        echo -e "\t$i"
    done

    echo -e "\n Examples:"
    echo -e "\n\t./bilygine.sh => Start the Bilygine and Monitoring stack in normal mode"
    echo -e "\t./bilygine.sh -d => Start the Bilygine and Monitoring stack in detach mode"
    echo -e "\t./bilygine.sh -d source db api => Start the source, analyzer and api services in detach mode"
    echo -e "\t./bilygine.sh analyzer api  => Start the Bilygine and Monitoring stack in normal mode"
    } 

up_all() {
    command="docker-compose -f docker-compose.yml -f docker-compose.monitoring.yml up $1"
    eval $command
    exit 0
}

stop_stack () {
    command="docker-compose -f docker-compose.yml -f docker-compose.prod.yml -f docker-compose.monitoring.yml down"
    eval $command
}

while getopts "hdrmkDp" opt; do
    case "$opt" in
    h)
        show_help
        exit 0
        ;;
    d)  
        detach="-d"
        ;;
    D)
        order="down"
        ;;
    r)
        order="restart"
        restart=1
        ;;
    m)
        monitor_file="-f docker-compose.monitoring.yml"
        m_stack="kapacitor influxdb telegraf chronograf"
        ;;
    k)
        order="kill"
        ;;
    p)
        prod=1
        production_file="-f docker-compose.prod.yml"
        ;;
    esac
done

if [ "$prod" == "1" ] ; then
    command="$command -f docker-compose.prod.yml"
else
    command="$command -f docker-compose.override.yml"
fi

command="$command $monitor"
if [ "$order" == "down" ] ; then
    stop_stack $command
    exit 0
fi

command="$command $order $detach"

count=0
for arg in "$@"
do
    for s in ${services[@]}
    do
        if [ "$s" == "$arg" ] ; then
            command="$command $arg"
            count=$((count+1))
        fi
    done
done

command="$command $m_stack"
eval $command
