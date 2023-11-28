FROM ubuntu:22.04

# Set environment variable for non-interactive installation.
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies.
RUN apt update && apt install -y \
    picocom \
    gawk \
    wget \
    git \
    diffstat \
    unzip \
    texinfo \
    gcc \
    build-essential \
    chrpath \
    socat \
    cpio \
    python3 \
    python3-pip \
    python3-pexpect \
    xz-utils \
    debianutils \
    iputils-ping \
    python3-git \
    python3-jinja2 \
    libegl1-mesa \
    libsdl1.2-dev \
    python3-subunit \
    mesa-common-dev \
    zstd \
    liblz4-tool \
    file \
    locales \
    zsh \
    python-is-python3 \
    git-lfs \
    meson \
    vim

# Add a non-root user.
ARG USERNAME=sd-dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Set zsh as the default shell.
RUN chsh -s /usr/bin/zsh $USERNAME

# Set the non-root user as the default user.
USER $USERNAME

# Make the non-root user the owner of the src directory.
RUN mkdir -p /home/$USERNAME/src
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/src

WORKDIR /home/$USERNAME
