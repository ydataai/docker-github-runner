# Github Runner on ~~steroids~~ Docker 🏃‍📦

An image for GitHub runner

This Dockerfile builds an image for a self-hosted github runner, replicating a github hosted runner, or at least trying to 😅

## How to use it

First of all, grab the `URL` and the `TOKEN` from the actions menu from the settins of your organization or repository, as instructed by GitHub docs [Adding self-hosted runners](https://help.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners).

The image accepts four enviroment variables, `URL` and `TOKEN` which are required, `NAME` and `WORKDIR` which are optional and have as default values `github-runner-docker` and `_work` respectively. 
We suggest you to at least change the `NAME` value and use the same as for the docker container.

The `TAG` for the image has the same value as the version of the github runner, not for all, so just check the [existing image tags](https://hub.docker.com/repository/docker/ydata/github-runner/tags). 
The `TAG` latest exists and points to the latest stable release in the [runner repository](https://github.com/actions/runner/releases).

Example:

```bash
NAME=github-runner-docker-1 \
URL='<YOUR URL>' \
TOKEN='<YOUR TOKEN>'; \
docker run -d --name=$NAME -e URL=$URL -e TOKEN=$TOKEN -e NAME=$NAME -v /var/run/docker.sock:/var/run/docker.sock ydataai/github-runner:2.169.1
```

## Installed Software

- Java 11
- [NVM](https://github.com/nvm-sh/nvm/blob/master/README.md) (Node Version Manager)
- Node 12.14 - Installed through NVM
- Swift 5.2.3

# About 👯‍♂️

With ❤️ from [YData](https://ydata.ai) [Development team](mailto://developers@ydata.ai)