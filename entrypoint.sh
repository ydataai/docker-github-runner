#! /bin/bash

set -e

if [ ! -z $@ ]; then
    exec $@
    return
fi

./config.sh --name $NAME --token $TOKEN --url $URL --work $WORKDIR --replace && ./run.sh
