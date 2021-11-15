# Create an image
clear

# Get what device to read from
fdisk -l
echo "What device is the SD card connected to? E.g., sdc, mmcblk0"
read devName

# Check to see if the user followed instructions and disks are located in /dev
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
#   if [[ $imageConfirmation == $failsafetesting ]]; then
    if [ -d ~/images ]; then
        echo "Images path exist, skipping"
    else
        echo "Create image path"
    fi
    dd if=/dev/$devName of=~/images/-+%Y%m%d_%H%M%S.img status=progress

# If the user fails the failsafe, bail
else
    echo "Confirmation failed, exiting"
    exit
fi
