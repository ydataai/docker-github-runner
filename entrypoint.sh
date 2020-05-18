#! /bin/bash

if [ ! -f ".runner" ]; then
    echo "Runner not configured. Configuring..."
    /bin/bash -i -c "source /home/github/.bashrc && ./config.sh --name $NAME --token $TOKEN --url $URL --work $WORKDIR --replace && exit"
fi

echo "Runner configured"

if [ ! -z $@ ]; then
    exec $@
else
    ./run.sh > runner.log
fi
