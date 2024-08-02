FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV WORKSPACE_BASE=/OpenDevin/workspace
ENV PROJECT_ROOT=/OpenDevin
ENV SCRIPT_DIR=""

RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common git sudo && \
    apt-get install -y netcat make && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://get.docker.com -o /tmp/get-docker.sh && \
    chmod 700 /tmp/get-docker.sh && \
    /tmp/get-docker.sh

RUN curl -fsSL https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -o /tmp/Mambaforge-Linux-x86_64.sh && \
    bash /tmp/Mambaforge-Linux-x86_64.sh -b -p /opt/conda && \
    rm /tmp/Mambaforge-Linux-x86_64.sh

ENV PATH="/opt/conda/bin:$PATH"

RUN git clone https://github.com/OpenDevin/OpenDevin /OpenDevin && \
    cd /OpenDevin && \
    git checkout 105f0ffed533b547c4ee9cc3d6a0ba11da38a6ca

WORKDIR /OpenDevin

RUN /opt/conda/bin/mamba create -y -n opendevin python=3.11 -c conda-forge && \
    /opt/conda/bin/mamba install -y -n opendevin -c conda-forge nodejs=18.17.1 && \
    /opt/conda/bin/mamba run -n opendevin pip install poetry>=1.8 && \
    /opt/conda/bin/mamba run -n opendevin poetry install && \
    /opt/conda/bin/mamba run -n opendevin poetry add build

COPY docker.toml /OpenDevin/config.toml
COPY evaluation/dummy/main.py /OpenDevin/evaluation/dummy/main.py

COPY entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]
