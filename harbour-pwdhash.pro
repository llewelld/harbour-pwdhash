TEMPLATE = subdirs
SUBDIRS = src translations
TARGET = harbour-pwdhash

OTHER_FILES += \
    rpm/$${TARGET}.spec
