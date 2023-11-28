#!/bin/bash -e

# Print the build information.
#
# Args: None
#
# Returns: None
function print_build_info {
    set -u
    echo "================================================================"
    echo "Build information:"
    echo "    Target: $TARGET"
    echo "    USER_BB_NUMBER_THREADS: $USER_BB_NUMBER_THREADS"
    echo "    USER_PARALLEL_MAKE: $USER_PARALLEL_MAKE"
    echo "    Build directory: $BUILD_DIR"
    echo "    SSTATE_DIR: $USER_SSTATE_DIR"
    echo "    DL_DIR: $USER_DL_DIR"
    echo "    Output image directory: $OUTPUT_IMAGE_DIR"
    echo "================================================================"
    set +u
}

# Build the image, and display the amount of time it took to build.
#
# Args: None
#
# Returns: None
function bitbake_build_with_time {
    # Get the current time, in seconds.
    local start_time=$(date +%s)

    # Build the target.
    ./execute_bitbake.sh $TARGET

    # Get the current time, in seconds.
    local end_time=$(date +%s)

    # Display the amount of time it took to build.
    local elapsed=$((end_time - start_time))
    local time_format=$(date -d@$elapsed -u +%H:%M:%S)
    echo "Build complete, total time: $time_format ($elapsed seconds)."
}

# Copy any images that were generated from the build into a local directory.
#
# Args: None
#
# Returns: None
function copy_build_images {
    local build_image_dir="${BUILD_DIR}/tmp/deploy/images"
    cp -p $build_image_dir -r $OUTPUT_IMAGE_DIR

    echo "Successfully copied generated images ($build_image_dir) into '${OUTPUT_IMAGE_DIR}'"
}

# Find the correct *.wic* file that was generated.
#
# Args: None
#
# Returns: None
function prepare_wic_file {
    # The generated *.wic* file is expected to be in the $OUTPUT_IMAGE_DIR/images/<machine>/ directory.
    local machine=$(./execute_bitbake.sh -e | grep "^MACHINE=" | cut -d'"' -f2)

    # Check the machine image output for a symbolic link to the .wic file.
    local machine_image_dir="${OUTPUT_IMAGE_DIR}/images/${machine}"
    local expected_symbolic_wic_filename="${TARGET}-${machine}.wic"
    local symbolic_wic_file=$(find $machine_image_dir -name "${expected_symbolic_wic_filename}")

    # If the symbolic link to a .wic was not found, look for a compressed wic (.wic.xz) file.
    local compressed=0
    if [ -z "$symbolic_wic_file" ]; then
        symbolic_wic_file=$(find $machine_image_dir -name "${expected_symbolic_wic_filename}.xz")
        compressed=1
    fi

    # Make sure we found some symbolic link.
    if [ -z "$symbolic_wic_file" ]; then
        echo "ERROR: Could not find a symbolic link to a ${expected_symbolic_wic} (or .xz) file in the output image directory."
        exit 1
    fi

    # The symbolic link was found - get the actual file name.
    local wic_file=$(readlink -f $symbolic_wic_file)

    # If the file is compressed, decompress it.
    local decompressed_wic_file=$wic_file
    if [ $compressed -eq 1 ]; then
        xz -d $wic_file
        decompressed_wic_file="${wic_file%.xz}"
    fi

    echo "Successfully prepared wic file ($decompressed_wic_file), which can be flashed to an SD card."
}

#############################################
# Main Script
#############################################

# Make sure we are in the directory where this script lives.
cd "$(dirname "$0")"

# Ensure the environment is setup.
source .envrc

# This script is not expecting any arguments. If any are provided, print an error and exit. 
if [ $# -ne 0 ]; then
    echo "ERROR: This script utilizes environment variables to build and thus does not expect any arguments."
    exit 1
fi

print_build_info

bitbake_build_with_time

copy_build_images

prepare_wic_file
