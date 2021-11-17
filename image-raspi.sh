#!/bin/bash
failsafe='I have confirmed all information is correct and understand the risks'
#failsafe='check'
processInput=''
user=''

# Check to see if being ran as root and if not elevate it to root
if [[ $UID != 0 ]]
then
    sudo ./image-raspi.sh
    exit
fi

# Disclaimer
clear
echo "This program, when used improperly, can irreversably destroy all data on your computer."
echo "This program contains absolutely no warranty where permissible by law."
echo "By continuing to use this program, you consent to the Terms of Service of this program and understand the risks."
echo "If you do not consent to the Terms of Service, please close the program now."
echo "This disclaimer will show for 10 seconds, press any key to continue"

# Sleep only commented out for testing
sleep 10
pause

# Commented out because mass imaging isn't quite ready
#echo "Would you like to Create an image, Restore an image, or Mass-restore images?"
#echo "C/R/M"
#read processInput

# Decide what process the user would like to run
clear
echo "Would you like to (C)reate an image or (R)estore an image"
echo "C/R"
read processInput

# Create an image
clear
if [[ $processInput == 'C' || $processInput == 'c' ]]
then

    # Get what device to read from
    fdisk -l
    echo ""
    echo "What device is the SD card connected to? E.g., sdc, mmcblk0"
    read devName

    # Check to see if the user followed instructions and disks are located in /dev
    clear
    if [ ! -e "/dev/$devName" ]; then
        echo "Either you included /dev/* or your disks are located in a different path other than /dev."
        exit
    fi
    
    # TODO: allow custom paths, for now saves to ~/images/
    echo "The image will be saved to ~/images and imaged from /dev/$devName"
    echo "Please ensure everything is correct, as this process is potentially dangerous."
    echo "Type in 'I have confirmed all information is correct and understand the risks' to proceed"
    read imageConfirmation

    # If the user successfully passes the failsafe, then create an image
    if [[ $imageConfirmation == $failsafe ]]; then
   #if [[ $imageConfirmation == $failsafetesting ]]; then
        if [ -d ~/images ]; then
            echo "Images path exist, skipping"
        else
            echo "Create image path"
        fi
        dd if=/dev/$devName of=~/images/image-`date +%Y%m%d_%H%M%S`.img status=progress
    
    # If the user fails the failsafe, bail
    else
        echo "Confirmation failed, exiting"
        exit
    fi
# Restore an image
elif [[ $processInput == 'R' || $processInput == 'r' ]]
then

    # Get what device to write to
    fdisk -l
    echo ""
    echo "What device is the SD card connected to? E.g., sdc, mmcblk0"
    read devName

    # Check to see if the user followed instructions and disks are located in /dev
    clear
    if [[ ! -e /dev/$devName ]]; then
        echo "Either you included /dev/* or your disks are located in a different path other than /dev."
        exit
    fi

    # Get what image to read from
    # and check its valididty
    # TODO: Allow custom paths, currently reads from ~/images
    clear
    if [[ ! -e ~/images/$imagePath ]]; then
        echo "The image you selected does not exist. Please ensure you typed the correct name out."
        exit
    else
        ls -ll ~/images
        echo ""
        echo "Select what image you'd like to read from"
        echo "(Hint: Press enter to the most recent image)"
        read imagePath
    fi

    # If user just presses enter, accept most recent file
    if [[ -z "$imagePath" ]]; then
        imagePath=$(ls -Art ~/images | tail -n 1)
    fi

    #Confirmation screen
    clear
    echo ""
    echo "The image " ~/images/$imagePath " and flashed to /dev/$devName"
    echo "Please ensure everything is correct, as this process is potentially dangerous."
    echo "Type in 'I have confirmed all information is correct and understand the risks' to proceed"
    read imageConfirmation

    # If the user successfully passes the failsafe, then create an image
    if [[ $imageConfirmation == $failsafe ]]; then
        echo "Imaging from " ~/images/$imagePath " to " /dev/$devName
        dd if=~/images/$imagePath of=/dev/$devName status=progress
    # If the user fails the failsafe, bail
    else
        echo "Confirmation failed, exiting"
        exit
    fi

# Mass image
elif [[ $processInput == 'M' || $processInput == 'm' ]]
then

    # Not ready yet, need to get a bit more comfortable with bash first
    # Easter egg: if they decide to try to get access to this, encourage them to contribute to the project.
    # Totally not me being lazy and just not wanting to comment out the elif statement
    echo "Multiple imaging isn't quite ready! If you feel confident, I encourage you to create a pull request or an issue with suggestions on github."
    echo "Even though you likely got this from github, you can create a pull request at https://github.com/TotallyMonica/image-raspi"
    # echo "Currently, only one destination is supported"
    echo "- Monica"
    exit

    # Get number of drives imaging to
    echo "How many drives are you imaging"
    read driveCount

    # Get number of physical drives to image at once
    # TODO: Clean up grammar, make it easier to read
    echo "How many physical drives can you connect at once?"
    read diskCount
    
    # TODO: add support for multiple destination disks. Currently, only one disk, so overriding user's input.
    diskCount = 1

    # List disks and get physical disk location
    fdisk -l
    for (( i=1; i<=diskCount; i++ ))
    do
        echo "Please enter the device for drive number " $i
        read devName
    done
    
    if [[ $diskCount == 1 ]]
    then
        clear
        echo ""
        echo "The image " ~/images/$imagePath " and flashed to /dev/$devName"
        echo "Please ensure everything is correct, as this process is potentially dangerous."
        echo "Type in 'I have confirmed all information is correct and understand the risks' to proceed"
        read imageConfirmation
        for (( i=1; i<=diskCount; i++ ))
        do
            dd if=~/images/$imagePath of=/dev/$devName status=progress
        done

    elif [[ $diskCount != 1 ]]
    then
        echo "Drive " "will be written to first, the rest will be queued up"
        imageCount = 1
        while driveCount < imageCount
        do
            dd if=~/image/imagePath of=/dev/$devName status=progress
        done
    fi

# If any of the other commands didn't run, 
else
    echo "You entered an invalid command."
    exit
fi
