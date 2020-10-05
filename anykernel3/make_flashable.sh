
#!~bin/bash

set -e

echo ' '
echo ' '
echo ' Setting Up AnyKernel3 '
echo ' '
echo ' '
echo ' '
echo ' Running & Making Flashable Kernel '
echo ' '

KERNEL_PATH="/home/Vevelo/firemax13/a70qkernel"
BINARIES_PATH="out/arch/arm64/boot/"

FIRE_KERNEL_VERSION="FireKernel_Revision_2.5"
FIRE_KERNEL_EDITION="_SuperEdition"
FIRE_KERNEL_STATUS="_Official"
BUILD_DATE="_$(date +%y%m%d)"
DEVICE_CODE="_a70q"
DEVICE_MODEL="_SM-A705"

echo ' Cleaning Up Old Binaries and flash file '
rm -rf *.gz-dtb *.zip
cp $KERNEL_PATH/$BINARIES_PATH/Image.gz-dtb Image.gz-dtb

zip -r9 $FIRE_KERNEL_VERSION$FIRE_KERNEL_STATUS$FIRE_KERNEL_EDITION$DEVICE_CODE$DEVICE_MODEL$BUILD_DATE.zip * -x .git README.md make_flashable.sh ramdisk/placeholder
