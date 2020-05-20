FROM ubuntu:18.04


ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true


# Update system and install required tools
RUN apt-get -qqy update && \
    apt-get -qqy upgrade && \
    apt-get -qqy install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        libgtk-3-0 \
        libpangocairo-1.0 \
        libxcursor1 \
        libxss1 \
        software-properties-common


# Install Swift
COPY swift.sh .
RUN chmod +x swift.sh && ./swift.sh && rm -rf swift.sh


# Add git apt repo, upgrade it and remove unecessary tools
RUN add-apt-repository ppa:git-core/ppa && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" && \
    apt-get -qqy remove docker docker-engine docker.io containerd runc && \
    apt-get -qqy update && \
    apt-get -qqy upgrade git && \
    apt-get -qqy install docker-ce docker-ce-cli containerd.io && \
    apt-get -qqy purge --auto-remove software-properties-common && \
    apt-get autoclean && \
    rm -r /var/lib/apt/lists/*


# Switch to user and setup shell
WORKDIR /github-runner
SHELL ["/bin/bash", "--login", "-i", "-c"]


# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && \
    source /root/.bashrc && \
    nvm install v12.14.1


SHELL ["/bin/bash", "--login", "-c"]


ARG runner_version="2.262.1"


# Download and extract github runner
RUN curl -O -L https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-linux-x64-${runner_version}.tar.gz && \
    tar xzf actions-runner-linux-x64-${runner_version}.tar.gz && \
    rm -rf actions-runner-linux-x64-${runner_version}.tar.gz


COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENV RUNNER_ALLOW_RUNASROOT true
ENV LABELS "ubuntu-18.04"
ENV NAME "github-runner-docker"
ENV URL ""
ENV TOKEN ""
ENV WORKDIR=""


ENTRYPOINT [ "./entrypoint.sh" ]
