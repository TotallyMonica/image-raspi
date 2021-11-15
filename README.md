# Image Raspberry Pi
## An easy-to-use imaging tool for Raspberry Pi's
There's a multitude of reasons why you'd want to be able to make multiple copies of a Raspberry Pi SD card, such as
 - Using for lessons on how to use a Raspberry Pi
 - Making backups
 - Using Raspbery Pis for identical or near-identical usage
 - 

## Usage:
`./image-raspi.sh`

## Why this?
To be perfectly honest, there's no real reason why this is more ideal over something like `rsnapshot`, `rsync`, or even just manually dd'ing images yourself. I just created this to be more convenient for me when I found myself consistently reading one image and writing that image to multiple drives.

## Future Features
This isn't organized in any certain way and assistance is definitely asked for. Also, suggest your own features!
 - Allow mass imaging to SD cards
 - Allow reading from multiple SD cards
 - Set up for one-line commands and arguments (nice for cron jobs)
 - Checking if being run as root
 - Backing up over the network (SSH, FTP, SFTP, etc.)
 - Windows and MacOS clients