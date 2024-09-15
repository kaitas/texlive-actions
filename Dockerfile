FROM debian:bullseye-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    texlive-base \
    texlive-lang-japanese \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-binaries \
    xdvik-ja \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workdir

CMD ["/bin/bash"]