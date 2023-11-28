#!/bin/bash -e

# Unmount each mounted device partition.
#
# Args: None
#
# Returns: None
function unmount_partitions {
    # Get a list of mounted partitions for the specified device. Do not throw error if nothing is grep'd.
    mounted_partitions=$(grep -oP "$DEVICE\d+" /proc/mounts) || [[ $? == 1 ]]

    # Unmount each mounted partition
    for partition in $mounted_partitions; do
        umount "$partition"
        if [ $? -eq 0 ]; then
            echo "Unmounted: $partition"
        else
            echo "Failed to unmount: $partition"
        fi
    done
}

# Set IMAGE to the last built image (i.e., the newest .wic file in the images directory).
#
# Args: None
#
# Returns: None
function set_newest_wic_image {
    # Directory to search in.
    local search_dir="${OUTPUT_IMAGE_DIR}/images/*"

    # Regular expression pattern to match filenames.
    local file_pattern="*.rootfs.wic"

    # Find the file with a matching file pattern that was last modified.
    local newest_file=$(ls -t $search_dir/$file_pattern | head -n 1)

    if [ -n "$newest_file" ]; then
        echo "Found newest $file_pattern file: $newest_file"
        IMAGE=$newest_file
    else
        echo "No matching files found."
        exit 1
    fi
}

# Flash the specified image to the specified device.
#
# Args: None
#
# Returns: None
function flash {
    echo "!!! Flashing $IMAGE to $DEVICE !!!"
    sudo dd if=$IMAGE of=$DEVICE status=progress bs=32M iflag=direct oflag=direct && sync
}

#############################################
# Main Script
#############################################

IMAGE=

USAGE="""Description:
   This script will unmount all partitions on a given device before flashing a .rootfs.wic image to the device.

   Note: if the current user does not have sudo privileges, the script will fail when attempting to flash the image.

Usage:
    $0 -d <device>            # Use the newest image in the images directory.
    $0 -i <image> -d <device> # Use the specified image.

Required Arguments:
    -d  Device to write to (typically an SD Card). Note: to find the device, run 'lsblk' before and after inserting the SD Card.
        The device will be the one that appears after inserting the SD Card.
        Example: /dev/sdc

Optional Arguments:
    [-i]  The image to flash. If not specified, the last built image is used.
    [-h]  Display this help message.

Examples:
    $0 -d /dev/sdc
    $0 -i core-image-minimal-beaglebone-20230811014814.rootfs.wic -d /dev/sdc"""

# Parse the command line arguments.
while getopts ":i:d:h" opt; do
    case $opt in
        i) IMAGE=$OPTARG ;;
        d) DEVICE=$OPTARG ;;
        h)
            echo "$USAGE"
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            echo "$USAGE"
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            echo "$USAGE"
            exit 1
            ;;
    esac
done

# Validate that the device exists.
if [ ! -e "$DEVICE" ]; then
    echo "Device $DEVICE does not exist."
    exit 1
fi

# Only get the newest image if one was not specified.
if [ -z "$IMAGE" ]; then
    set_newest_wic_image
fi

# Validate that the image exists.
if [ ! -e "$IMAGE" ]; then
    echo "Image $IMAGE does not exist."
    exit 1
fi

unmount_partitions

flash
