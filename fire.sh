#!/bin/bash

set -e

echo "FireKernel Builder"

# Put the Kernel Path in here and fire it up
# No need to change the whole and entire file to set-up kernel path
KERNEL_PATH=$(pwd)
TOOLCHAIN_PATH=/home/$USER
BINARIES_OUT_PATH=out/arch/arm64/boot
COMPLETE_OUT_PATH=$KERNEL_PATH/$BINARIES_OUT_PATH
DEFCONFIG=a70q_eur_open_defconfig

# For separated GCC & Clang Path
# GCC_PATH=
# CLANG_PATH=

# Export GCC and ARCH
export CROSS_COMPILE=$TOOLCHAIN_PATH/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export ARCH=arm64

if [ "$2" == "do-overlay" ]; then
	export CONFIG_BUILD_ARM64_DT_OVERLAY=y
fi

if [ "$1" == "clean" ]; then
	rm -rf out
fi

# Clean UP anykernel3 old output binaries & flash zips
if [ "$1" == "clean" ]; then
        rm -rf AnyKernel3/*.zip AnyKernel3/*.gz-dtb
fi

# Output hacking & tricking
if [ ! -d out ]; then
	mkdir out
fi

# Types, paths, and more etc.
BUILD_CROSS_COMPILE=$TOOLCHAIN_PATH/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$TOOLCHAIN_PATH/clang-r377782d/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-

make -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE $DEFCONFIG
make -j8 -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE

if [ "$2" == "do-overlay" ]; then
	tools/mkdtimg create $BINARIES_OUT_PATH/dtbo.img --page_size=4096 $(find out -name "*.dtbo")
fi

# Copy Image.gz-dtb into anykernel3 folder [WIP]
# cp $COMPLETE_OUT_PATH/Image.gz-dtb AnyKernel3/Image.gz-dtb
