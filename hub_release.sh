#!bin/bash

set -e

# For Hub Release Action & Less efforts

VER="3.0"
EDITION="FrostEdition"
ED="FE"
RELEASE_NAME="FireKernel Official Rev $VER $EDITION for Galaxy A70"
TAG="$VER$ED"
TAG_COMMIT="039fd38777b77e5dd6bd05d63dd7a37dc2d5f561"

git remote -v

hub release create -a $(pwd)/AnyKernel3/*.zip -m "$RELEASE_NAME" -t $TAG_COMMIT $TAG
