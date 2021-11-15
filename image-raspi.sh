#!/bin/bash
failsafe='I have confirmed all information is correct and understand the risks'
processInput='C'

# Commented out because mass imaging isn't quite ready
#echo "Would you like to Create an image, Restore an image, or Mass-restore images?"
#echo "C/R/M"
#read processInput

# Decide what process the user would like to run
echo "Would you like to Create an image or Restore an image"
echo "C/R"
#read processInput

# Create an image
if [[ processInput==C || processInput == c ]]
then

    # Get what device to read from
    fdisk -l
    echo "What device is the SD card connected to? E.g., sdc, mmcblk0"
    read devName

    # Check to see if the user followed instructions and disks are located in /dev
    if [ ! -e /dev/$devName]; then
        echo "Either you included /dev/* or your disks are located in a different path other than /dev."
        exit
    fi
    
    # TODO: allow custom paths, for now saves to ~/images/
    echo "The image will be saved to ~/images and imaged from /dev/$devName"
    echo "Please ensure everything is correct, as this process is potentially dangerous."
    echo "Type in 'I have confirmed all information is correct and understand the risks' to proceed"
    read imageConfirmation

    # If the user successfully passes the failsafe, then create an image
    if imageConfirmation == failsafe; then
        mkdir ~/images
        dd if=/dev/$devName of=~/images/-+%Y%m%d_%H%M%S.img status=progress
    
    # If the user fails the failsafe, bail
    else
        echo "Confirmation failed, exiting"
        exit
    fi
fi
# Restore an image
if [[ processInput == R || processInput == r ]]
then

    # Mark as a valid option
    runSuccess = 1

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
    if [ ! -e ~/images/imagePath]; then
        echo "The image you selected does not exist. Please ensure you typed the correct name out."
        exit
    fi

    echo "The image will be saved to ~/images and flashed to /dev/$devName"
    echo "Please ensure everything is correct, as this process is potentially dangerous."
    echo "Type in 'I have confirmed all information is correct and understand the risks' to proceed"
    read imageConfirmation

    # If the user successfully passes the failsafe, then create an image
    if imageConfirmation == failsafe; then
        mkdir ~/images
        dd if=~/images/$imagePath of=/dev/$devName status=progress
    
    # If the user fails the failsafe, bail
    else
        echo "Confirmation failed, exiting"
        exit
    fi

fi
# Mass image
if [[ processInput == M || processInput == m ]]
then

    # Mark as a valid option
    runSuccess = 1

    # Not ready yet, need to get a bit more comfortable with bash first
    # Easter egg: if they decide to try to get access to this, encourage them to contribute to the project.
    echo "Multiple imaging isn't quite ready! If you feel confident, I encourage you to create a pull request or an issue with suggestions on github."
    echo "Even though you likely got this from github, you can create a pull request at https://github.com/TotallyMonica/image-raspi"
    echo "- Monica"
    exit

    # Get number of drives imaging to
    echo "How many drives are you imaging"
    read driveCount

    # Get number of physical drives to image at once
    # TODO: Clean up grammar, make it easier to read
    echo "How many physical drives can you connect at once?"
    read diskCount

    # List disks and get physical disk location
    fdisk -l
    #for (( i=1; i<=diskCount; i++ ))
fi

# If any of the other commands didn't run, 
if [[ runSuccess == 0 ]]; then
    echo "You entered an invalid command."
fi