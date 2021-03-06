#!/bin/sh

if [ $# -eq 1 ]; then
    COPY_FROM=$1
    test ! -d "$COPY_FROM" && echo error reading dir "$COPY_FROM" && exit 1
fi

test -z "$DEVICE" && echo device not set && exit 2
test -z "$VENDOR" && echo vendor not set && exit 2
test -z "$VENDORDEVICEDIR" && VENDORDEVICEDIR=$DEVICE
export VENDORDEVICEDIR

BASE=../../../vendor/$VENDOR/$VENDORDEVICEDIR/proprietary
rm -rf $BASE/*
rm -rf $BASE/../packages 2> /dev/null
for FILE in `cat ../msm8960-common/common-proprietary-files.txt | grep -v ^# | cut -f1 -d '#' | grep -v ^$`; do
    DIR=`dirname $FILE`
    if [ ! -d $BASE/$DIR ]; then
        mkdir -p $BASE/$DIR
    fi
    if [ "$COPY_FROM" = "" ]; then
        adb pull /system/$FILE $BASE/$FILE
    else
        cp -p "$COPY_FROM/$FILE" $BASE/$FILE
    fi
done
for FILE in `cat ../${DEVICE}/device-proprietary-files.txt | grep -v ^# | cut -f1 -d '#' | grep -v ^$`; do
    DIR=`dirname $FILE`
    if [ ! -d $BASE/$DIR ]; then
        mkdir -p $BASE/$DIR
    fi
    if [ "$COPY_FROM" = "" ]; then
        adb pull /system/$FILE $BASE/$FILE
    else
        cp -p "$COPY_FROM/$FILE" $BASE/$FILE
    fi
done
    if [ -d $BASE/app ]; then
        mkdir -p ${BASE}/../packages
        mv $BASE/app/* ${BASE}/../packages/
    fi
rmdir ${BASE}/app 2> /dev/null


../msm8960-common/setup-makefiles.sh
