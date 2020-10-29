#!/bin/bash

set -e

echo "FireKernel Builder"

#
## Put the Kernel Path in here and fire it up
## No need to change the whole and entire file to set-up kernel path
#
KERNEL_PATH=$(pwd)
TOOLCHAIN_PATH=/home/$USER
BINARIES_OUT_PATH=out/arch/arm64/boot
COMPLETE_OUT_PATH=$KERNEL_PATH/$BINARIES_OUT_PATH
DEFCONFIG=fire_defconfig
CLANG_VEREV=clang-r377782d

#
## For separated GCC & Clang Path
#
# GCC_PATH=$TOOLCHAIN_PATH/aarch64-linux-android-4.9/bin/aarch64-linux-android-
# CLANG_PATH=$TOOLCHAIN_PATH/$CLANG_VEREV/bin/clang

#
## Export GCC and ARCH
#
export CROSS_COMPILE=$TOOLCHAIN_PATH/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export ARCH=arm64

#
## For dtbo & dtbs compile
#
if [ "$2" == "do-overlay" ]; then
	export CONFIG_BUILD_ARM64_DT_OVERLAY=y
fi

#
## Unexport & Unset some none useful exports
#
unset USE_CCACHE=1
unset CCACHE_EXEC=/usr/bin/ccache

#
## Clean OutPut Folder
#
if [ "$1" == "do-clean" ]; then
	rm -rf out
fi

#
## Clean UP anykernel3 old output binaries & flash zips
#
if [ "$1" == "do-clean" ]; then
        rm -rf AnyKernel3/*.zip AnyKernel3/*.gz-dtb AnyKernel3/dtbo.img
fi

#
## Output hacking & tricking
#
if [ ! -d out ]; then
	mkdir out
fi

#
## Types, paths, and more etc.
#
BUILD_CROSS_COMPILE=$TOOLCHAIN_PATH/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$TOOLCHAIN_PATH/$CLANG_VEREV/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-

make -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE $DEFCONFIG
make -j8 -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE

#
## Make dtboimages if launched
#
if [ "$2" == "do-overlay" ]; then
	tools/mkdtimg create $BINARIES_OUT_PATH/dtbo.img --page_size=4096 $(find out -name "*.dtbo")
fi

#
## Copy Image.gz-dtb into anykernel3 folder [WIP]
#
if [ "$3" == "do-copy" ]; then
	cp $COMPLETE_OUT_PATH/Image.gz-dtb AnyKernel3/Image.gz-dtb
fi

$(pwd) $COMPLETE_OUT_PATH
echo " " "4.14.183"
