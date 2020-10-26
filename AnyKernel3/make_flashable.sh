#!bin/bash
# Custom Flashable Effort Less Maker
# Copyright 2021, firemax13@github.com

set -e

echo " " " "
echo "Fire Kernel Flashable Maker"
echo " " " "
echo "Setting Up Please Wait"
echo " " " "

echo "Setting Proper Directories"
KERNEL_PATH="/home/$USER/a70qkernel"
BINARIES_PATH="out/arch/arm64/boot/"
ANYKERNEL_DIR="$(pwd)"

echo "Setting FireKernel Versions"
FIRE_KERNEL_VERSION="FireKernel_Revision_3.3"
FIRE_KERNEL_EDITION="_FrostExtremeEdition"
FIRE_KERNEL_STATUS="_Official"
BUILD_DATE="_$(date +%y%m%d)"
DEVICE_CODE="_a70q"
DEVICE_MODEL="_SM-A705"
echo " "

echo "Cleaning Up Old Binaries and flash file"
rm -rfv *.gz-dtb *.zip
echo " " " "

echo "Copying Kernel Binaries"
cp -v $KERNEL_PATH/$BINARIES_PATH/Image.gz-dtb Image.gz-dtb
echo " " " "

echo "Making Flashable"
zip -r9 $FIRE_KERNEL_VERSION$FIRE_KERNEL_STATUS$FIRE_KERNEL_EDITION$DEVICE_CODE$DEVICE_MODEL$BUILD_DATE.zip * -x .git README.md make_flashable.sh ramdisk/placeholder
echo " " " "
echo "Done! Ready to Flash & Fuel to the device"
