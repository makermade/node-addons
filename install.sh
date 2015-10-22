#!/bin/bash

# This script is for testing install an add-on to target.
#
# For example, after full build you may want install another
# npm package - promise.
#
# You can do this in project root:
#
#  $ ./node-addons/install.sh promise
#  $ ./build.sh snod
#
# After testing the add-on in target, and you want to add promise
# to system build, you should add promise to Android.mk

SCRIPTPATH=$(cd $(dirname $0); pwd -P)

. $SCRIPTPATH/../load-config.sh

if [[ ! -n $DEVICE ]]; then
	echo DEVICE is not set
	exit 128
fi
export PATH=$SCRIPTPATH/../out/host/linux-x86/bin:$PATH
export TOOLCHAIN=$SCRIPTPATH/../toolchain/linux-x86/gcc-linaro-arm-linux-gnueabihf-4.8-2014.04_linux/bin
export AR=$TOOLCHAIN/arm-linux-gnueabihf-ar
export CC=$TOOLCHAIN/arm-linux-gnueabihf-gcc
export CXX=$TOOLCHAIN/arm-linux-gnueabihf-g++
export LINK=$TOOLCHAIN/arm-linux-gnueabihf-g++
export npm_config_arch=arm
export npm_config_nodedir=$SCRIPTPATH/../node/
export npm_config_prefix=$SCRIPTPATH/../out/target/product/$DEVICE/system/
npm install -g --target_arch=arm $1
