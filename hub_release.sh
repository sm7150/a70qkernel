set -e

# For Hub Release Action & Less efforts

# Skip Echo & Reclean
echo " "
echo " "
echo " "
echo "HubEffort Less Releaser & File WorkFlows"
echo " "
echo " "
echo "Setting Up Proper Release Name"
echo " "

# Proper Release Names & Versions
VER="5.0"
EDITION="FrostExtremeFrontierEdition"
ED="FEFE"
RELEASE_NAME="FireKernel Official Dev $VER $EDITION for Galaxy A80"
TAG="$VER$ED"
TAG_COMMIT="$2"

# Skip Echo & Reclean
echo " " " "

# Use -r (recursive) to bypass no-commit release
# & make commit with releases
if [ "$1" == "-r" ]; then
	echo "Recursive Mode Activated"
	echo "Bypassing No Commit Release"
fi

# Kill if lunch number one is number two
if [ "$1" == "$2" ]; then
	^C
fi

# Skip Echo & Reclean
echo " " " "

# Make Releases without Commits
if [ "$1" == "-nc" ]; then
	echo " " " " "Releasing Project Without Commit Hashes"
        hub release create -a $(pwd)/AnyKernel3/*.zip -m "$RELEASE_NAME" $TAG
fi

if [ "$2" == "$TAG_COMMIT" ]; then
	echo " " " " "Releasing Project With Commit Hashes"
	hub release create -a $(pwd)/AnyKernel3/*.zip -m "$RELEASE_NAME" -t $TAG_COMMIT $TAG
fi
