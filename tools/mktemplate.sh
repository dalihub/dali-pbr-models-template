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
WORKING_DIR=$(readlink -f $(readlink -f $0 | xargs dirname)/..)
if [ $# -gt 2 ]; then
	WORKING_DIR=$3
fi

echo "Working directory is $WORKING_DIR ..."

# Check that the script is in the correct location
SOURCE_NAME=hellodali
SOURCE_PATH=$(readlink -f $WORKING_DIR/$SOURCE_NAME)
if [ ! -d $SOURCE_PATH ]; then
	echo Error: hellodali template missing.
	exit 1
fi

# Copy build config
TARGET_SPEC_DIR=$WORKING_DIR/packaging
TARGET_BUNDLE=$2
TARGET_SPEC=$TARGET_SPEC_DIR/$TARGET_BUNDLE.spec
echo "Creating build config in $TARGET_SPEC ..."
if [ ! -d "$TARGET_SPEC_DIR" ]; then
	# If need be, create packaging directory.
	mkdir $TARGET_SPEC_DIR
fi

SOURCE_BUNDLE=com.samsung.dali-scene-hellodali

cp $SOURCE_PATH/../packaging/$SOURCE_BUNDLE.spec $TARGET_SPEC

# Replace bundle name and template name in spec
sed -i "s/$SOURCE_BUNDLE/$TARGET_BUNDLE/g" $TARGET_SPEC
sed -i "s/$SOURCE_NAME/$TARGET_NAME/g" $TARGET_SPEC

# Copy template directory
echo "Creating template in $WORKING_DIR/$TARGET_NAME ..."
cp -r $SOURCE_PATH $WORKING_DIR/$TARGET_NAME

# Replace bundle name and template name in the rest of the configuration files.
sed -i "s/$SOURCE_BUNDLE/$TARGET_BUNDLE/g" $WORKING_DIR/$TARGET_NAME/$SOURCE_BUNDLE.*
sed -i "s/$SOURCE_NAME/$TARGET_NAME/g" $WORKING_DIR/$TARGET_NAME/$SOURCE_BUNDLE.*

# Rename configuration files.
for file in $WORKING_DIR/$TARGET_NAME/$SOURCE_BUNDLE.*
do
	EXTENSION=${file##*.}
	mv $file $(dirname $file)/$TARGET_BUNDLE.$EXTENSION
done

# Rename icon
ICON_PATH=$WORKING_DIR/$TARGET_NAME/share/icons
mv $ICON_PATH/$SOURCE_BUNDLE.png $ICON_PATH/$TARGET_BUNDLE.png

# Rename .dli just to be pedantic
MODELS_PATH=$WORKING_DIR/$TARGET_NAME/resources/models/scenes
mv $MODELS_PATH/hello-dali.dli $MODELS_PATH/$TARGET_NAME.dli

echo "Done."

