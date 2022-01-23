#!/bin/bash

build=0
update=0
config=0

show_help() {
    echo -e "\n Usage:"
    echo -e "\t/install.sh [-hucb]"
    echo -e "\n\t-h : Display this help"
    echo -e "\t-u : Update the git repo of all services"
    echo -e "\t-c : Copy the base config files of analyzer, kapacitor, influxdb and telegraf"
    echo -e "\t-b : Build analyzer jar and all Docker images"
    echo -e "\t-f : Force rebuild of Docker images"
    echo -e "\n Examples:"
    echo -e "\n\t./install.sh => Update, configure and build all services"
    echo -e "\t./bilygine.sh -u => Update source code but doesn't rebuild"
    } 

update_repo () {

repo=(mediator analyzer api_gateway bridge console)

for i in ${repo[@]}; do
    echo -e "\n###################"
    echo -e "UPDATING $i SOURCE CODE"
    echo -e "###################\n"
    if [ ! -d "$i" ] ; then
        git clone git@github.com:Bilygine/$i.git
    else
        cd $i
	git fetch
	git checkout master
	git fetch
        git pull
        cd - > /dev/null
    fi
done
}


base_config() {

echo -e "\n###################"
echo -e "COPYING CONF FILES"
echo -e "###################\n"

mkdir -p telegraf
mkdir -p influxdb/config
mkdir -p kapacitor/config
mkdir -p analyzer/analyzer-core/conf
cp conf/telegraf-conf/* telegraf
cp conf/influxdb-conf/* influxdb/config
cp conf/kapacitor-conf/* kapacitor/config
cp conf/analyzer-conf/* analyzer/analyzer-core/conf
if [[ ! -f ".env" ]] ; then
	echo "BILYGINE_HOSTNAME=localhost" > .env
	echo "API_PREFIX=api." >> .env
	echo "BRIDGE_PREFIX=bridge." >> .env
	echo "DB_PREFIX=db." >> .env
	echo "MONITOR_PREFIX=monitor." >> .env
fi
}

build_all () {

echo -e "\n###################"
echo -e "BUILDING ANALYZER"
echo -e "###################\n"
cd analyzer/analyzer-core
mvn install
if [ "$?" != "0" ] ; then
    echo -e "\n###################"
    echo -e "ERROR : FAIL TO BUILD ANALYZER !! ABORTING"
    echo -e "CHECK THAT JAVA AND MAVEN ARE INSTALLED ON YOUR SYSTEM"
    echo -e "\n###################"
    exit 1
fi

cd - > /dev/null

echo -e "\n###################"
echo -e "BUILDING DOCKER IMAGES"
echo -e "###################\n"
sleep 3

docker-compose build --parallel --force-rm $force

}

while getopts "hbucf" opt; do
    case "$opt" in
    h)
        show_help
        exit 0
        ;;
    u)  
        update=1
        ;;
    c)
        config=1
        ;;
    b)
        build=1
        ;;
    f)
        force="--no-cache"
    esac
done

if [[ -z "$@" ]] ; then
    build=1
    update=1
    config=1
fi

if [ "$update" -eq 1 ] ; then
    update_repo
fi

if [ "$config" -eq 1 ] ; then
    base_config
fi

if [ "$build" -eq 1 ] ; then
    build_all
fi

if [ ! -d "credentials" ] ; then
    mkdir -p credentials
    echo -e "\n###################"
    echo -e "WARNING !!"
    echo -e "COPY YOUR GOOGLE CREDENTIALS INTO 'credentials' FOLDER"
    echo -e "###################\n"
fi
