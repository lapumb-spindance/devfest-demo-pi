#!/bin/bash -eu

# Enter the directory where this script is located. 
cd $(dirname $0)

# Make sure devcontainer CLI is installed.
if [ ! command -v devcontainer &> /dev/null ]; then
    echo "devcontainer CLI could not be found. Please see the top-level README.md"
    exit 1
fi

# Make sure the Docker daemon is running.
if [ ! docker info &> /dev/null ]; then
    echo "Docker daemon is not running. Please start the Docker daemon."
    exit 1
fi

# Create and run the devcontainer.
devcontainer up --workspace-folder ../

# Enter the devcontainer.
docker exec -w /home/sd-dev/src/yocto-starter-kit -it --user sd-dev yocto-starter-kit zsh
