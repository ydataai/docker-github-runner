FROM ubuntu:18.04


ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true


# Update system and install required tools
RUN apt-get -qy update && \
    apt-get -qy upgrade && \
    apt-get -qy install \
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
    apt-get -qy remove docker docker-engine docker.io containerd runc && \
    apt-get -qy update && \
    apt-get -qy upgrade git && \
    apt-get -qy install docker-ce docker-ce-cli containerd.io && \
    apt-get -qy purge --auto-remove software-properties-common && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*


# Switch to user and setup shell
ENV USER github
RUN useradd -m -s /bin/bash -N ${USER} && \
    usermod -aG docker,root ${USER}
USER ${USER}
WORKDIR /home/${USER}
SHELL ["/bin/bash", "--login", "-i", "-c"]


# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && \
    source /home/${USER}/.bashrc && \
    nvm install v12.14.1


SHELL ["/bin/bash", "--login", "-c"]


# Download and extract github runner
RUN curl -O -L https://github.com/actions/runner/releases/download/v2.169.1/actions-runner-linux-x64-2.169.1.tar.gz && \
    tar xzf actions-runner-linux-x64-2.169.1.tar.gz && \
    rm -rf actions-runner-linux-x64-2.169.1.tar.gz


COPY --chown=github:users entrypoint.sh .
RUN chmod +x entrypoint.sh


ENV NAME="github-runner-docker"
ENV URL ""
ENV TOKEN ""
ENV WORKDIR="_work"


ENTRYPOINT [ "./entrypoint.sh" ]
