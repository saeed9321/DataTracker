ARCHS = arm64 arm64e
TARGET = iphone:clang:14.7.1:13.0
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2222
GO_EASY_ON_ME = 1
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SDATA
$(BUNDLE_NAME)_BUNDLE_EXTENSION = bundle
$(BUNDLE_NAME)_FILES = $(wildcard Toggle/*.m) $(wildcard Toggle/*.xm) $(wildcard Components/*.m) $(wildcard Calendar/*.m)
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-protocol
$(BUNDLE_NAME)_LIBRARIES = substrate
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = ControlCenterUIKit
$(BUNDLE_NAME)_INSTALL_PATH = /Library/ControlCenter/Bundles/

include $(THEOS_MAKE_PATH)/bundle.mk

