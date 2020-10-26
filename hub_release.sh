#!bin/bash
# Custom Hub Release Actions for File Releasing
# Copyright 2021, firemax13@github.com

set -e

# For Hub Release Action & Less efforts

echo " "
echo "Setting Up Proper Release Name"
VER="3.3"
EDITION="FrostExtremeEdition"
ED="FEE"
RELEASE_NAME="FireKernel Official Rev $VER $EDITION for Galaxy A70"
TAG="$VER$ED"
TAG_COMMIT="$1"
echo " "

git status
echo " "

echo "Releasing..."
hub release create -a $(pwd)/AnyKernel3/*.zip -m "$RELEASE_NAME" -t $TAG_COMMIT $TAG
