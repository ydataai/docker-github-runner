FROM swift:5.2

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Update system and install required tools
RUN apt-get -qy update && \
    apt-get -qy upgrade && \
    apt-get -qy install \
        curl \
        software-properties-common


# Add git apt repo, upgrade it and remove unecessary tools
RUN add-apt-repository ppa:git-core/ppa && \
    apt-get -qy upgrade git && \
    apt-get -qy purge --auto-remove software-properties-common && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*


# Setup user to run github runner
ENV USER github
RUN useradd -m -s /bin/bash -N ${USER}
USER ${USER}
WORKDIR /home/${USER}


# Install nvm
SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && \
    source /home/${USER}/.bashrc && \
    nvm install v12.14.1
SHELL ["/bin/bash", "--login", "-c"]


# Download and extract github runner
RUN curl -O -L https://github.com/actions/runner/releases/download/v2.169.1/actions-runner-linux-x64-2.169.1.tar.gz && \
    tar xzf actions-runner-linux-x64-2.169.1.tar.gz


COPY --chown=github:users entrypoint.sh .
RUN chmod +x entrypoint.sh


ENV NAME="github-runner-docker"
ENV URL ""
ENV TOKEN ""
ENV WORKDIR="_work"


ENTRYPOINT [ "./entrypoint.sh" ]