#! /bin/bash

CMD="/bin/bash -i -c"

if [ ! -f ".runner" ]; then
    echo "Runner not configured. Configuring..."
    $CMD "source /home/github/.bashrc && ./config.sh --name $NAME --token $TOKEN --url $URL --work $WORKDIR --replace && exit"
fi

echo "Runner configured"

if [ ! -z $@ ]; then
    exec $@
else
    $CMD "./run.sh > runner.log"
fi
