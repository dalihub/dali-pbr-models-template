#!/bin/sh

# Check arguments needed.
if [ $# -lt 2 ]; then
	echo Usage: mktemplate [template-name] [bundle-id]
	exit 1
fi

# Check that we aren't overwriting anything.
if [ -d $1 ]; then
	echo Error: $1 already exists.
	exit 1
fi

# Check that the script is in the correct location
SOURCE_NAME=hellodali
SOURCE_PATH=$(readlink -f $0 | xargs dirname)/../$SOURCE_NAME
echo $SOURCE_PATH
if [ ! -d $SOURCE_PATH ]; then
	echo Error: hellodali template missing.
	exit 1
fi

# Copy build config
if [ ! -d "packaging" ]; then
	# If need be, create packaging directory.
	mkdir packaging
fi

SOURCE_BUNDLE=com.samsung.dali-scene-hellodali

TARGET_SPEC=packaging/$2.spec
cp $SOURCE_PATH/../packaging/$SOURCE_BUNDLE.spec $TARGET_SPEC

# Replace bundle name and template name in spec
sed -i "s/$SOURCE_BUNDLE/$2/g" $TARGET_SPEC
sed -i "s/$SOURCE_NAME/$1/g" $TARGET_SPEC

# Copy template directory
cp -r $SOURCE_PATH $1

# Replace bundle name and template name in the rest of the configuration files.
sed -i "s/$SOURCE_BUNDLE/$2/g" $1/$SOURCE_BUNDLE.*
sed -i "s/$SOURCE_NAME/$1/g" $1/$SOURCE_BUNDLE.*

# Rename configuration files.
for file in $1/$SOURCE_BUNDLE.*
do
	EXTENSION=${file##*.}
	mv $file $(dirname $file)/$2.$EXTENSION
done

# Rename icon
ICON_PATH=$1/share/icons
mv $ICON_PATH/$SOURCE_BUNDLE.png $ICON_PATH/$2.png

# Rename .dli just to be pedantic
MODELS_PATH=$1/resources/models/scenes
mv $MODELS_PATH/hello-dali.dli $MODELS_PATH/$1.dli
