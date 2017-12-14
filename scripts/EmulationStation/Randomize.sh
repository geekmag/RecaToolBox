#!/usr/bin/env bash
SPLASH_PATH=/recalbox/system/resources/splash
RECATOOLBOX_RESOURCE_DIR=$SPLASH_PATH/RecaToolBox
VIDEO_INTRO_PATH=$RECATOOLBOX_RESOURCE_DIR/videos
FILE_LIST=()
for filename in $VIDEO_INTRO_PATH/*.mp4
do
    FILE_LIST+=("$filename")
done
FILE_LIST_SIZE=${#FILE_LIST[@]}
if [ $FILE_LIST_SIZE != "0" ];
then
    if [ -L $SPLASH_PATH/recalboxintro.mp4 ]; then
        unlink $SPLASH_PATH/recalboxintro.mp4
    elif [ -f $SPLASH_PATH/recalboxintro.mp4 ]; then
        rm $SPLASH_PATH/recalboxintro.mp4
    fi
    VIDEO_INDEX=$((RANDOM%FILE_LIST_SIZE))
    SELECTED_VIDEO=${FILE_LIST[$VIDEO_INDEX]}
    ln -sfn $SELECTED_VIDEO $SPLASH_PATH/recalboxintro.mp4

    if [ -f $SELECTED_VIDEO.length ]; then
       cp $SELECTED_VIDEO.length $RECATOOLBOX_RESOURCE_DIR/videoLength.sh
    else
       echo "VIDEO_LENTGH=0" > $RECATOOLBOX_RESOURCE_DIR/videoLength.sh
    fi
fi
