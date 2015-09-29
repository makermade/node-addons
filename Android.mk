LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := node_modules
LOCAL_MODULE_CLASS := DATA
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
include $(BUILD_PREBUILT)

# quirks:
#   nodejs will search /system/lib/node instead of /system/lib/node_modules
$(LOCAL_INSTALLED_MODULE): $(LOCAL_BUILT_MODULE)
	tar xf $(addsuffix .tar,$<) -C $(TARGET_OUT)
	ln -s node_modules $(@D)/node

# explaination of the quirks:
#   PATH: for using the built host npm, not the preinstalled on the host
#   npm install -g XXX: install the host npm packages, such as node-pre-gyp
#   remains are for cross compiling
$(LOCAL_BUILT_MODULE): $(TARGET_OUT)/bin/nodejs
	mkdir -p $@
	(cd node-addons; \
	export PATH=$(ANDROID_BUILD_TOP)/out/host/linux-x86/bin:$$PATH; \
	npm install -g node-pre-gyp; \
	export TOOLCHAIN=$(ANDROID_BUILD_TOP)/toolchain/linux-x86/gcc-linaro-arm-linux-gnueabihf-4.8-2014.04_linux/bin; \
	export AR=$$TOOLCHAIN/arm-linux-gnueabihf-ar; \
	export CC=$$TOOLCHAIN/arm-linux-gnueabihf-gcc; \
	export CXX=$$TOOLCHAIN/arm-linux-gnueabihf-g++; \
	export LINK=$$TOOLCHAIN/arm-linux-gnueabihf-g++; \
	export npm_config_arch=arm; \
	export npm_config_nodedir=$(ANDROID_BUILD_TOP)/node/; \
	export npm_config_prefix=$(abspath $@); \
	npm install -g --target_arch=arm \
	  node-serialport; \
	)
	(cd $@; tar cf ../node_modules.tar .)
