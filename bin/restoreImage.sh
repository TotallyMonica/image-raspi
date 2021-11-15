#!/bin/bash

failsafe='I have confirmed all information is correct and understand the risks'
#failsafetesting='check'
processInput=''

# Get what device to write to
fdisk -l
echo "What device is the SD card connected to? E.g., sdc, mmcblk0"
read devName

# Get what image to read from
# TODO: Allow custom paths, currently reads from ~/images
ls ~/images
echo "Select what image you'd like to read from"
read imagePath

# Check to see if the user followed instructions and disks are located in /dev
if [ ! -e /dev/$devName]; then
    echo "Either you included /dev/* or your disks are located in a different path other than /dev."
    exit
fi

# Check to see if image is valid
if [ ! -e ~/images/$imagePath]; then
    echo "The image you selected does not exist. Please ensure you typed the correct name out."
    exit
else
    ls -ll ~/images
    echo "Select the image that you'd like to image"
    read imagePath
fi

echo "The image " ~/images/$imagePath " and flashed to /dev/$devName"
echo "Please ensure everything is correct, as this process is potentially dangerous."
echo "Type in 'I have confirmed all information is correct and understand the risks' to proceed"
read imageConfirmation

# If the user successfully passes the failsafe, then create an image
if [[ $imageConfirmation == $failsafe ]]; then
    echo "dd if=~/images/$imagePath of=/dev/$devName status=progress"
    echo "Imaging from " ~/images/$imagePath " to " /dev/$devName
# If the user fails the failsafe, bail
else
    echo "Confirmation failed, exiting"
    exit
fi