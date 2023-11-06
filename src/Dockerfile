FROM ubuntu:22.04

ARG RUNNER_VERSION="2.311"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get upgrade -y && useradd -m docker
RUN apt-get install -y --no-install-recommends \
    curl nodejs wget unzip vim git jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -o actions-runner-linux-x64-${RUNNER_VERSION}.0.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}.0/actions-runner-linux-x64-${RUNNER_VERSION}.0.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.0.tar.gz

RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

ADD start.sh start.sh
RUN chmod +x start.sh

USER docker
ENTRYPOINT ["./start.sh"]
