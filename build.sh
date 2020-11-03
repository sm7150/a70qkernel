#!/bin/bash
#
# Kanged from Chartur@Github.com
# Copyright 2020 - Fire-CLI.flows
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Set default directories
HOME_DIR=/home/$USER
ROOT_DIR=$(pwd)
OUT_DIR=$ROOT_DIR/out
IMAGES_OUT=$OUT_DIR/arch/arm64/boot
DTB_OUT=$IMAGES_OUT/dts/qcom
COMPLETE_OUT=$ROOT_DIR/$IMAGES_OUT
KERNEL_DIR=$ROOT_DIR
ANYKERNEL_DIR=$(pwd)/AnyKernel3/

# Toolchains (Clang & GCC) directories & paths
CLANG_OWNER=Google
CLANG_VERSION=10.0.6
CLANG_REVISION=clang-r377782d
CLANG_BIN=$HOME_DIR/$CLANG_REVISION/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-

# Set default kernel variables
PROJECT_NAME="Fire Kernel"
CORES=8
TYPE="OFFICIAL"
REV=3.5.9b
USER=firemax13
BUILD_HOST=Fire-CLI.flows

# Export commands
export KBUILD_BUILD_USER=$USER
export KBUILD_BUILD_HOST=$BUILD_HOST
export ARCH=arm64
export CROSS_COMPILE=$HOME_DIR/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CC=$CLANG_BIN
export CLANG_TRIPLE=$CLANG_TRIPLE

# Unset ccache
unset USE_CCACHE
unset CCACHE_EXEC

# Get date and time
DATE=$(date +"%m-%d-%y")
BUILD_START=$(date +"%s")

# Device Lists, Models & Defconfigs
SM_M515="Samsung Galaxy M51"
M51_DEF=m51_eur_open_defconfig
M51_MODEL=M515
M51_CODE=m51

SM_A705="Samsung Galaxy A70"
A70Q_DEF=fire_defconfig
A70Q_MODEL=A705
A70Q_CODE=a70q

SM_A715="Samsung Galaxy A71"
A71_DEF=a71_eur_open_defconfig
A71_MODEL=A715
A71_CODE=a71

SM_A805="Samsung Galaxy A80"
R1Q_DEF=r1q_eur_open_defconfig
R1Q_MODEL=A805
R1Q_CODE=r1q

# Android Export Versions
androidq="Android 10 (Q)"
androidr="Android 11 (R)"
10/Q=q
11/R=r

################### Executable functions #######################
CLEAN_SOURCE()
{
	echo "*****************************************************"
	echo "*							  *"
	echo "*             Cleaning Output & Sources             *"
	echo "*                                                   *"
	echo "*****************************************************"
	rm -rfv out AnyKernel3/*.zip AnyKernel3/*.gz-dtb AnyKernel3/*.img
	CLEAN_SUCCESS=$?
	if [ $CLEAN_SUCCESS != 0 ]
		then
			echo "Error: Clean Failed"
			exit
	fi
}

BUILD_KERNEL()
{
	echo "*****************************************************"
	echo "*                                                   *"
	echo "* 	Building Kernel For Choosen Device        *"
	echo "*							  *"
	echo "*****************************************************"
	export ANDROID_MAJOR_VERSION=$ANDROID
	make $DEFCONFIG
	make -j$CORES
	sleep 1
}

ZIPPIFY()
{
	# Make FireKernel Flashable Zip Using AnyKernel3
	if [ -e "$IMAGES_OUT/Image.gz-dtb" ]
	then
	{
		echo -e "*****************************************************"
		echo -e "*                                                   *"
		echo -e "*         Building FireKernel Flashable Zip         *"
		echo -e "*                                                   *"
		echo -e "*****************************************************"

		# Copy Image and dtbo.img to anykernel directory
		cp -fv $IMAGES_OUT/Imgae.gz-dtb AnyKernel3/Image.gz-dtb
		if [ -e "$IMAGES_OUT/dtbo.img" ]
		then
		{
			cp -fv arch/$ARCH/boot/dtbo.img AnyKernel3/dtbo.img
		}
		fi
		# Go to anykernel directory
		cd AnyKernel3
		zip -r9 $ZIPNAME * -x .git dtbo.img README.md make_flashable.sh
		if [ -e "AnyKernel3/dtbo.img" ]
		then
		{
			zip -r9 $ZIPNAME * -x .git README.md make_flashable.sh
		}
		fi
		# Set Flashable Zip Permission
		chmod 0777 *.zip
		# Change back into kernel source directory
		cd ..
		sleep 1
	}
	fi
}

PROCESSES()
{
	# Allow user to choose how many cores to be taken by compiler
	echo "Your system has $CORES cores."
	read -p "Please enter how many cores to be used by compiler (Leave blank to use all cores) : " cores;
	if [ "${cores}" == "" ]; then
		echo " "
		echo "Using all $CORES cores for compilation"
		sleep 2
	else
		echo " "
		echo "Using $cores cores for compilation"
		CORES=$cores
		sleep 2
	fi
}

ENTER_VERSION()
{
	# Enter kernel revision for this build.
	read -p "Please type kernel version without R (E.g: 4.7) : " rev;
	if [ "${rev}" == "" ]; then
		echo " "
		echo "Using '$REV' as version"
	else
		REV=$rev
		echo " "
		echo "Version: $REV"
	fi
	sleep 2
}

EDITION()
{
	# Set Fire Kernel Edition
	read -p "Please set Fire Kernel Edition : " edition;
	if [ "${edition}" == "${edition}" ]; then
		echo " "
		echo " "
		EDITION=$edition
		echo "Using Edition: $rev"
		sleep 2
	else if [ "${edition}" == "" ]; then
		echo "Invalid Edition"
		exit 1
	fi
}

USER()
{
	# Setup KBUILD_BUILD_USER
	echo "Current build username is $USER"
	echo " "
	read -p "Please type build_user (E.g: Firemax13) : " user;
	if [ "${user}" == "" ]; then
		echo " "
		echo "Using '$USER' as Username"
	else
		export KBUILD_BUILD_USER=$user
		echo " "
		echo "build_user = $user"
	fi
	sleep 2
}

RENAME()
{
	# Give proper name to kernel and zip name
	ZIPNAME="FireKernel_Revision_"$REV"_"$STATUS"_"$EDITION"_"$DEVICE_CODE"_"$DEVICE_MODEL"_"$BUILD_DATE".zip"
}

DISPLAY_ELAPSED_TIME()
{
	# Find out how much time build has taken
	BUILD_END=$(date +"%s")
	DIFF=$(($BUILD_END - $BUILD_START))

	BUILD_SUCCESS=$?
	if [ $BUILD_SUCCESS != 0 ]
		then
			echo "Error: Build failed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds $reset"
			exit
	fi

	echo -e "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds $reset"
	sleep 1
}

COMMON_STEPS()
{
	echo "*****************************************************"
	echo "                                                     "
	echo "        Starting compilation of $DEVICE_Axxx kernel  "
	echo "                                                     "
	echo " Defconfig = $DEFCONFIG                              "
	echo "                                                     "
	echo "*****************************************************"
	RENAME
	sleep 1
	echo " "
	BUILD_KERNEL
	echo " "
	sleep 1
	ZIPPIFY
	sleep 1
	sleep 1
	CLEAN_SOURCE
	sleep 1
	echo " "
	DISPLAY_ELAPSED_TIME
	echo " "
	echo "                 *****************************************************"
	echo "*****************                                                     *****************"
	echo "                      $DEVICE_Axxx kernel for Android $AND_VER build finished          "
	echo "*****************                                                     *****************"
	echo "                 *****************************************************"
}

OS_MENU()
{
	# Give the choice to choose Android Version
	PS3='
Please select your Android Version: '
	menuos=("$androidq" "$androidr" "Exit")
	select menuos in "${menuos[@]}"
	do
	    case $menuos in
		"$androidq")
			echo " "
			echo "Android 10 (Q) chosen as Android Major Version"
			ANDROID=q
			AND_VER=10
			sleep 2
			echo " "
			break
			;;
		"$androidr")
			echo " "
			echo "Android 11 (R) chosen as Android Major Version"
			ANDROID=r
			AND_VER=11
			sleep 2
			echo " "
			break
			;;
		"Exit")
          		echo " "
          		echo "Exiting build script.."
          		sleep 2
			echo " "
          		exit
            		;;
        	*)
        		echo "Invalid option"
        		;;
		esac
	done
}


#################################################################


###################### Script starts here #######################

CLEAN_SOURCE
clear
PROCESSES
clear
ENTER_VERSION
clear
EDITION
clear
USER
clear
UPDATE_BUILD_FILES
clear
echo "******************************************************"
echo "*             $PROJECT_NAME Build Script             *"
echo "*                  Developer: Chatur                 *"
echo "*                Co-Developer: Gabriel               *"
echo "*                                                    *"
echo "*          Compiling kernel using Linaro-GCC         *"
echo "*                                                    *"
echo "* Some information about parameters set:             *"
echo -e "*  > Architecture: $ARCH                             *"
echo    "*  > Jobs: $CORES                                         *"
echo    "*  > Revision for this build: R$REV                   *"
echo    "*  > Version chosen: $TYPE                           *"
echo    "*  > Kernel Name Template: $VERSION    *"
echo    "*  > Build user: $KBUILD_BUILD_USER                              *"
echo    "*  > Build machine: $KBUILD_BUILD_HOST                       *"
echo    "*  > Build started on: $BUILD_START                    *"
echo    "*  > ARM64 Toolchain exported                        *"
echo -e "******************************************************"
echo " "

echo "Devices avalaible for compilation: "
echo " "
PS3='
Please select your device: '
menuoptions=("$SM_M515" "$SM_A705X" "$SM_A715" "$SM_A805" "Exit")
select menuoptions in "${menuoptions[@]}"
do
    case $menuoptions in
        "$SM_M515")
        	echo " "
        	echo "Android versions available: "
        	echo " "
		OS_MENU
		echo " "
		DEVICE_Axxx=$SM_M515
		DEFCONFIG=$M51_DEF
		COMMON_STEPS
		break
		;;
        "$SM_A705")
		echo " "
        	echo "Android versions available: "
        	echo " "
		OS_MENU
		echo " "
		DEVICE_Axxx=$SM_A705
		DEFCONFIG=$A70Q_DEF
		COMMON_STEPS
		break
		;;
	"$SM_A715")
		echo " "
        	echo "Android versions available: "
        	echo " "
		OS_MENU
		echo " "
		DEVICE_Axxx=$SM_A715
		DEFCONFIG=$A71_DEF
		COMMON_STEPS
		break
		;;
	"$SM_A805")
		echo " "
        	echo "Android versions available: "
        	echo " "
		OS_MENU
		echo " "
		DEVICE_Axxx=$SM_A805
		DEFCONFIG=$R1Q_DEF
		COMMON_STEPS
		break
		;;
	"Exit")
            	echo "Exiting build script.."
          	sleep 2
          	exit
          	;;
        *)
        	echo "Invalid option"
        	;;
    esac
done

