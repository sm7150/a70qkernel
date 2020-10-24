#!bin/bash

set -e

# For Hub Release Action & Less efforts

VER="3.3"
EDITION="FrostExtremeEdition"
ED="FEE"
RELEASE_NAME="FireKernel Official Rev $VER $EDITION for Galaxy A70"
TAG="$VER$ED"
TAG_COMMIT="$1"

git remote -v

hub release create -a $(pwd)/AnyKernel3/*.zip -m "$RELEASE_NAME" -t $TAG_COMMIT $TAG
