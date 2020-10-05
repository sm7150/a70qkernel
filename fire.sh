#!/bin/bash

set -e

# Put the Kernel Path in here and fire it up
# No need to change the whole and entire file to set-up kernel path
KERNEL_PATH=/home/Vevelo/firemax13/a70qkernel
TOOLCHAIN_PATH=/home/Vevelo/firemax13

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
KERNEL_LLVM_BIN=$TOOLCHAIN_PATH/clang-r353983c/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="CONFIG_BUILD_ARM64_DT_OVERLAY=y"

make -C $KERNEL_PATH O=$KERNEL_PATH/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE a70q_eur_open_defconfig
make -j16 -C $KERNEL_PATH O=$KERNEL_PATH/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE

tools/mkdtimg create out/arch/arm64/boot/dtbo.img --page_size=4096 $(find out -name "*.dtbo")
tools/mkdtimg create out/arch/arm64/boot/recovery_dtbo --page_size=4096 $(find out -name "*.dtbo")
