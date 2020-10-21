#!bin/bash

set -e

# For Hub Release Action & Less efforts

VER="3.0"
EDITION="FrostEdition"
ED="FE"
RELEASE_NAME="FireKernel Official Rev $VER $EDITION for Galaxy A70"
TAG="$VER$ED"

git remote -v

hub release create -a $(pwd)/AnyKernel3/*.zip -m "$RELEASE_NAME" $TAG_COMMIT $TAG
