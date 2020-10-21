#!/bin/bash

set -e

echo "FireKernel Builder"

# Put the Kernel Path in here and fire it up
# No need to change the whole and entire file to set-up kernel path
KERNEL_PATH=$(pwd)
TOOLCHAIN_PATH=/home/$USER
BINARIES_OUT_PATH=out/arch/arm64/boot
COMPLETE_OUT_PATH=$KERNEL_PATH/$BINARIES_OUT_PATH

# For separated GCC & Clang Path
# GCC_PATH=
# CLANG_PATH=

# Export GCC and ARCH
export CROSS_COMPILE=$TOOLCHAIN_PATH/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export ARCH=arm64

# CleanUP Output Folder
rm -rf out
rm -rf out

# Output hacking & tricking
if [ ! -d out ]; then
	mkdir out
fi

# Types, paths, and more etc.
BUILD_CROSS_COMPILE=$TOOLCHAIN_PATH/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$TOOLCHAIN_PATH/clang-r377782d/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="CONFIG_BUILD_ARM64_DT_OVERLAY=y"

make -C $(pwd) O=$KERNEL_PATH/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE a70q_eur_open_defconfig
make -j8 -C $(pwd) O=$KERNEL_PATH/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE

tools/mkdtimg create $BINARIES_OUT_PATH/dtbo.img --page_size=4096 $(find out -name "*.dtbo")
tools/mkdtimg create $BINARIES_OUT_PATH/recovery_dtbo --page_size=4096 $(find out -name "*.dtbo")

# Clean UP anykernel3 old output binaries & flash zips
rm -rf AnyKernel3/*.zip AnyKernel3/*.gz-dtb

# Copy Image.gz-dtb into anykernel3 folder [WIP]
# cp $COMPLETE_OUT_PATH/Image.gz-dtb AnyKernel3/Image.gz-dtb
