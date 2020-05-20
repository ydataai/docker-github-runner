#! /bin/bash

CMD="/bin/bash -i -c"

if [ -z $WORKDIR ]; then
    echo "💥 WORKDIR has to be defined to some value on your host!"
    exit 1
fi

if [ ! -f ".runner" ]; then
    echo "Runner not configured. Configuring..."
    $CMD "source /root/.bashrc && ./config.sh --labels $LABELS --name $NAME --token $TOKEN --url $URL --work $WORKDIR --replace && exit"
fi

echo "Runner configured"

if [ ! -z $@ ]; then
    exec $@
else
    $CMD "./run.sh > runner.log"
fi
