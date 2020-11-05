#!bin/bash
# Custom Hub Release Actions for File Releasing
# Copyright 2021, firemax13@github.com

set -e

# For Hub Release Action & Less efforts

echo " "
echo "Setting Up Proper Release Name"
VER="3.9"
EDITION="FrostExtremeEdition"
ED="FEE"
RELEASE_NAME="FireKernel Official Rev $VER $EDITION for Galaxy A70"
TAG="$VER$ED"
TAG_COMMIT="$2"
echo " "

if [ "$1" == "-recursive" ]; then
	echo "Recursive Mode Activated"
	echo " "
fi

if [ "$1" == "$2" ]; then
	^C
fi

git status
echo " "

if [ "$3" == "-no-commit" ]; then
	echo "Release without commit hashes"
        hub release create -a $(pwd)/AnyKernel3/*.zip -m "$RELEASE_NAME" $TAG
fi

if [ "$2" == "$TAG_COMMIT" ]; then
	echo "Releasing with commit hashes"
	hub release create -a $(pwd)/AnyKernel3/*.zip -m "$RELEASE_NAME" -t $TAG_COMMIT $TAG
fi
