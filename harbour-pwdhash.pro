TEMPLATE = subdirs
SUBDIRS = src
TARGET = harbour-pwdhash

OTHER_FILES += \
    rpm/$${TARGET}.yaml \
    rpm/$${TARGET}.spec
