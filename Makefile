ifndef THEOS
$(error THEOS is not set. Run: export THEOS=~/theos)
endif

TARGET := iphone:clang:15.6:15.0
ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ByeAnnoyingChargingText

ByeAnnoyingChargingText_FILES = Tweak.xm
ByeAnnoyingChargingText_CFLAGS = -fobjc-arc
ByeAnnoyingChargingText_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"
