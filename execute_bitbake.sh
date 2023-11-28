#!/bin/bash -e

function print_error {
    local red="\033[0;31m"
    local no_color="\033[0m"
    echo -e "${red}ERROR: $1${no_color}"
}

# Setup the dependent directories used by bitbake, which includes creating both the download and sstate directories
# along with the build directory, where the user configuration (/conf) files are copied into.
#
# Args: None
#
# Returns: None
function setup_dependent_dirs {
    set -u

    # Create the sstate and download directory if they don't exist.
    mkdir -p $USER_SSTATE_DIR
    mkdir -p $USER_DL_DIR

    # Create the build directory if it does not exist, and copy the local configuration files into it.
    mkdir -p $BUILD_DIR
    cp -r conf/ $BUILD_DIR

    # Create the output image directory if it does not exist.
    mkdir -p $OUTPUT_IMAGE_DIR

    set +u
}

#############################################
# Main Script
#############################################

# Validate the REPO_ROOT. If it is not set, the environment has not been setup.
if [ -z "$REPO_ROOT" ]; then
    print_error "The REPO_ROOT environment variable is not set. Please run 'source .envrc' to setup the environment."
    exit 1
fi

setup_dependent_dirs

# Setup the environment.
source poky/oe-init-build-env $BUILD_DIR

# Pass in the necessary environment variables and execute the bitbake command.
#
# NOTE: if an underlying script depends on an environment variable that was not added to 
# BB_ENV_PASSTHROUGH_ADDITIONS, then it will not be able to find it.
BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS REPO_ROOT USER_SSTATE_DIR USER_DL_DIR USER_BB_NUMBER_THREADS USER_PARALLEL_MAKE" \
    REPO_ROOT=$REPO_ROOT \
    USER_SSTATE_DIR=$USER_SSTATE_DIR \
    USER_DL_DIR=$USER_DL_DIR \
    USER_BB_NUMBER_THREADS=$USER_BB_NUMBER_THREADS \
    USER_PARALLEL_MAKE=$USER_PARALLEL_MAKE \
    bitbake $@ # pass in any arguments to this script.