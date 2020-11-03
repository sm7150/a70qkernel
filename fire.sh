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
FIRE_DEFCONFIG=fire_defconfig
R1Q_DEFCONFIG=r1q_eur_open_defconfig
M51_DEFCONFIG=m51_eur_open_defconfig
A70Q_DEFCONFIG=a70q_eur_open_defconfig
A71_DEFCONFIG=a71_eur_open_defconfig
SM7150_DEF=sm7150_sec_defconfig
SM6150_DEF=sm6150_sec_defconfig
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
if [ "$3" == "-dv" ]; then
	export CONFIG_BUILD_ARM64_DT_OVERLAY=y
fi

#
## Unexport & Unset some none useful exports
#
unset USE_CCACHE
unset CCACHE_EXEC

#
## Clean OutPut Folder
#
if [ "$2" == "-c" ]; then
	rm -rf out
fi

#
## Clean UP anykernel3 old output binaries & flash zips
#
if [ "$2" == "-c" ]; then
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

if [ "$1" == "-a70q" ]; then
	make -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE $FIRE_DEFCONFIG
	make -j8 -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE
fi
if [ "$1" == "-a71" ]; then
	make -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE $A71_DEFCONFIG
	make -j8 -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE
fi
if [ "$1" == "-a80" ]; then
	make -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE $R1Q_DEFCONFIG
	make -j8 -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE
fi
if [ "$1" == "-m51" ]; then
	make -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE $M51_DEFCONFIG
	make -j8 -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE
fi

if [ "$1" == "$2" ]; then
	^C
fi

#
## Make dtboimages if launched
#
if [ "$3" == "-dv" ]; then
	tools/mkdtimg create $BINARIES_OUT_PATH/dtbo.img --page_size=4096 $(find out -name "*.dtbo")
fi

#
## Copy Image.gz-dtb into anykernel3 folder [WIP]
#
if [ "$4" == "-cp" ]; then
	cp $COMPLETE_OUT_PATH/Image.gz-dtb AnyKernel3/Image.gz-dtb
fi

ls $COMPLETE_OUT_PATH
echo "4.14.183"
