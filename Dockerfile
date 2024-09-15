FROM debian:bullseye-slim

# Update and install essential packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget \
    gpg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add TeX Live repository
RUN wget -qO- https://www.tug.org/texlive/files/texlive.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/texlive.gpg && \
    echo "deb http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/debian/ unstable main" > /etc/apt/sources.list.d/texlive.list

# Install TeX Live packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    texlive-base \
    texlive-lang-japanese \
    texlive-latex-extra \
    texlive-fonts-recommended \
    xdvik-ja \
    dvipsk-ja \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workdir

CMD ["/bin/bash"]