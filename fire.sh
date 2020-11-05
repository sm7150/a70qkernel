#!/bin/bash

set -e

echo "FireKernel Builder"
echo " "

# Directories & Paths
KERNEL_PATH=$(pwd)
TOOLCHAIN_PATH=/home/$USER
DIR_NAME=a70qkernel

# Output Path Binaries
BINARIES_OUT_PATH=out/arch/arm64/boot
COMPLETE_OUT_PATH=$KERNEL_PATH/$BINARIES_OUT_PATH

# Device Supported Defconfig
FIRE_DEFCONFIG=fire_defconfig
R1Q_DEFCONFIG=r1q_eur_open_defconfig
M51_DEFCONFIG=m51_eur_open_defconfig
A70Q_DEFCONFIG=a70q_eur_open_defconfig
A71_DEFCONFIG=a71_eur_open_defconfig
SM7150_DEF=sm7150_sec_defconfig
SM6150_DEF=sm6150_sec_defconfig

# User & Team Exportions
USER_BUILDER=firemax13
USER_TEAM=Fire-CLI.flows

# Targeted Build Variants
TARGET_BUILD_VARIANT=user

# Toolcahin/Clang Settings, Versions & Name
BUILD_CROSS_COMPILE=$TOOLCHAIN_PATH/aarch64-linux-android-4.9/bin/aarch64-linux-android-
CLANG_BIN=$TOOLCHAIN_PATH/clang-r377782d/bin/clang
CLANG_VEREV=clang-r377782d
CLANG_TRIPLE=aarch64-linux-gnu-

# Unexport & Unset some none useful exports
unset USE_CCACHE
unset CCACHE_EXEC

# Export Toolchain, Clang & Arch
export ARCH=arm64
export CROSS_COMPILE=$TOOLCHAIN_PATH/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export REAL_CC=$TOOLCHAIN_PATH/clang-r377782d/bin/clang
export CLANG_TRIPLE=$CLANG_TRIPLE
export KBUILD_BUILD_USER=$USER_BUILDER
export KBUILD_BUILD_HOST=$USER_TEAM
export TARGET_BUILD_VARIANT=user

# Compile DTB & DTBO Images
if [ "$3" == "-dv" ]; then
	export CONFIG_BUILD_ARM64_DT_OVERLAY=y
fi

# Clean Output Folder & Output Binaries
if [ "$2" == "-c" ]; then
	rm -rf out AnyKernel3/*.zip AnyKernel3/*.gz-dtb AnyKernel3/dtbo.img
fi

# Clean Main Output Folders
if [ ! -d out ]; then
	mkdir out
fi

# Build & Compile Starts Here With Device Specs
if [ "$1" == "-a70q" ]; then
	make -C $(pwd) O=$(pwd)/out $FIRE_DEFCONFIG
	make -j8 -C $(pwd) O=$(pwd)/out
fi
if [ "$1" == "-a71" ]; then
	make -C $(pwd) O=$(pwd)/out $A71_DEFCONFIG
	make -j8 -C $(pwd) O=$(pwd)/out
fi
if [ "$1" == "-a80" ]; then
	make -C $(pwd) O=$(pwd)/out $R1Q_DEFCONFIG
	make -j8 -C $(pwd) O=$(pwd)/out
fi
if [ "$1" == "-m51" ]; then
	make -C $(pwd) O=$(pwd)/out $M51_DEFCONFIG
	make -j8 -C $(pwd) O=$(pwd)/out
fi

# Exit If Lunch No One Is Number Two
if [ "$1" == "$2" ]; then
	^C
fi

# Make dtboimages if launched
if [ "$3" == "-dv" ]; then
	tools/mkdtimg create $BINARIES_OUT_PATH/dtbo.img --page_size=4096 $(find out -name "*.dtbo")
fi

ls $COMPLETE_OUT_PATH
echo "4.14.183"
