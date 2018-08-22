#!/bin/sh

# Check arguments needed.
if [ $# -lt 2 ]; then
	echo Usage: mktemplate [template-name] [bundle-id] [working directory \(optional\)]
	exit 1
fi

# Check that we aren't overwriting anything.
TARGET_NAME=$1
if [ -d $TARGET_NAME ]; then
	echo Error: "$TARGET_NAME" already exists.
	exit 1
fi

# Working directory
WORKING_PATH=$(readlink -f $(readlink -f $0 | xargs dirname)/..)
if [ $# -gt 2 ]; then
	WORKING_PATH=$3
fi

echo "Working directory is $WORKING_PATH ..."

# Check that the script is in the correct location
SOURCE_NAME=hellodali
SOURCE_PATH=$(readlink -f $WORKING_PATH/$SOURCE_NAME)
if [ ! -d $SOURCE_PATH ]; then
	echo Error: hellodali template missing.
	exit 1
fi

# Copy build config
TARGET_SPEC_PATH=$WORKING_PATH/packaging
TARGET_BUNDLE=$2
TARGET_SPEC=$TARGET_SPEC_PATH/$TARGET_BUNDLE.spec
echo "Creating build config in $TARGET_SPEC ..."
if [ ! -d "$TARGET_SPEC_PATH" ]; then
	# If need be, create packaging directory.
	mkdir $TARGET_SPEC_PATH
fi

SOURCE_BUNDLE=com.samsung.dali-scene-hellodali

cp $SOURCE_PATH/../packaging/$SOURCE_BUNDLE.spec $TARGET_SPEC

# Replace bundle name and template name in spec
sed -i "s/$SOURCE_BUNDLE/$TARGET_BUNDLE/g" $TARGET_SPEC
sed -i "s/$SOURCE_NAME/$TARGET_NAME/g" $TARGET_SPEC

# Copy manifests & smack rules.
TARGET_PATH=$WORKING_PATH/$TARGET_NAME
echo "Instantiating template in $TARGET_PATH ..."
mkdir $TARGET_PATH
cp $SOURCE_PATH/$SOURCE_BUNDLE.* $TARGET_PATH

# Replace bundle name and template name in the rest of the configuration files.
sed -i "s/$SOURCE_BUNDLE/$TARGET_BUNDLE/g" $TARGET_PATH/$SOURCE_BUNDLE.*
sed -i "s/$SOURCE_NAME/$TARGET_NAME/g" $TARGET_PATH/$SOURCE_BUNDLE.*

# Rename configuration files.
for file in $WORKING_PATH/$TARGET_NAME/$SOURCE_BUNDLE.*
do
	EXTENSION=${file##*.}
	mv $file $(dirname $file)/$TARGET_BUNDLE.$EXTENSION
done

# Copy resources
cp -r $SOURCE_PATH/resources $TARGET_PATH
cp -r $SOURCE_PATH/share $TARGET_PATH

# Copy CMakeLists.txt and nothing else
mkdir $TARGET_PATH/build $TARGET_PATH/build/tizen
cp $SOURCE_PATH/build/tizen/CMakeLists.txt $TARGET_PATH/build/tizen/

# Rename icon
ICON_PATH=$WORKING_PATH/$TARGET_NAME/share/icons
mv $ICON_PATH/$SOURCE_BUNDLE.png $ICON_PATH/$TARGET_BUNDLE.png

# Rename .dli just to be pedantic
MODELS_PATH=$WORKING_PATH/$TARGET_NAME/resources/models
mv $MODELS_PATH/hello-dali.dli $MODELS_PATH/$TARGET_NAME.dli

echo "Done."

