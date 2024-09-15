FROM debian:bullseye-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    texlive-full \
    texlive-lang-japanese \
    texlive-lang-cjk \
    xdvik-ja \
    dvipsk-ja \
    gv \
    psutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workdir

CMD ["/bin/bash"]