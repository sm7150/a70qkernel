set -e

# Echo Reclean & Sets
echo " " " "
echo "Fire Kernel Flashable Maker"
echo " " " "
echo "Setting Up Please Wait"
echo " " " "

# Directories Properties
echo "Setting Proper Directories"
KERNEL_PATH="/home/$USER/a70qkernel"
BINARIES_PATH="out/arch/arm64/boot"
ANYKERNEL_DIR="$(pwd)"

# Version Properties & File Types
echo "Setting FireKernel Versions"
FIRE_KERNEL_VERSION="FireKernel_Developer_5.0"
FIRE_KERNEL_EDITION="_FrostExtremeFrontierEdition"
FIRE_KERNEL_STATUS="_Official-Dev"
BUILD_DATE="_$(date +%y%m%d)"
DEVICE_CODE="_A70Q"
DEVICE_MODEL="_SM-A705"
echo " "

# Cleanup Outputs & Binaries
echo "Cleaning Up Old Binaries and flash file"
rm -rfv *.gz-dtb *.zip *.img dtbo.img recovery_dtbo
echo " " " "

# Copy Binaries to AnyKernel3 Diretory
echo "Copying Kernel Binaries"
cp -v $KERNEL_PATH/$BINARIES_PATH/Image.gz-dtb Image.gz-dtb
echo " " " "

# Include dtbo images if launched
if [ "$1" == "incl-dtbo" ]; then
	echo "Warning Please Edit anykernel.sh to Make dtbo flashable!"
	nano -c anykernel.sh
fi

if [ "$1" == "incl-dtbo" ]; then
	cp -v $KERNEL_PATH/$BINARIES_PATH/dtbo.img dtbo.img
fi

# Make & Start
echo "Making Flashable"
zip -r9 $FIRE_KERNEL_VERSION$FIRE_KERNEL_STATUS$FIRE_KERNEL_EDITION$DEVICE_CODE$DEVICE_MODEL$BUILD_DATE.zip * -x .git README.md make_flashable.sh ramdisk/placeholder
echo " " " "
echo "Done! Ready to Flash & Fuel to the device"
