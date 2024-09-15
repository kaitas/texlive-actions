FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y \
    texlive-full \
    && rm -rf /var/lib/apt/lists/*

RUN tlmgr update --self && \
    tlmgr update --all

WORKDIR /workdir

CMD ["/bin/bash"]