# Copyright (c) 2013-2014, Zhang Yungui, https://github.com/rhcad/touchvg
#
LOCAL_PATH := $(call my-dir)
CORE_PATH  := ../../../thirdparty/TouchVGCore/android/TouchVGCore/obj/local/armeabi
CORE_INC   := $(LOCAL_PATH)/../../../thirdparty/TouchVGCore/core/include

include $(CLEAR_VARS)
LOCAL_MODULE    := libTouchVGCore
LOCAL_SRC_FILES := $(CORE_PATH)/libTouchVGCore.a
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE           := touchvg
LOCAL_LDLIBS           := -L$(SYSROOT)/usr/lib -llog -lGLESv1_CM -lGLESv2
LOCAL_PRELINK_MODULE   := false
LOCAL_CFLAGS           := -frtti -Wall -Wextra -Wno-unused-parameter
LOCAL_STATIC_LIBRARIES := libTouchVGCore

ifeq ($(TARGET_ARCH),arm)
# Ignore "note: the mangling of 'va_list' has changed in GCC 4.4"
LOCAL_CFLAGS += -Wno-psabi
endif

LOCAL_C_INCLUDES := $(CORE_INC) \
                    $(CORE_INC)/geom \
                    $(CORE_INC)/graph \
                    $(CORE_INC)/canvas \
                    $(CORE_INC)/shape \
                    $(CORE_INC)/storage \
                    $(CORE_INC)/cmd \
                    $(CORE_INC)/cmdbase \
                    $(CORE_INC)/cmdobserver \
                    $(CORE_INC)/test \
                    $(CORE_INC)/view \
                    $(CORE_INC)/cmdbasic \
                    $(CORE_INC)/cmdmgr \
                    $(CORE_INC)/jsonstorage \
                    $(CORE_INC)/shapedoc

LOCAL_SRC_FILES  := touchvg_java_wrap.cpp

include $(BUILD_SHARED_LIBRARY)
