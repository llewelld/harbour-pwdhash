# The name of your application
TARGET = harbour-pwdhash

CONFIG += sailfishapp
PKGCONFIG += \
    openssl \
    mlite5

SOURCES += \
    src/appsettings.cpp \
    src/digest.cpp \
    src/main.cpp \
    src/zxcvbn.cpp

HEADERS += \
    src/appsettings.h \
    src/digest.h \
    src/version.h \
    src/zxcvbn.h \
    src/dict-src.h

DISTFILES += \
    qml/*.qml \
    qml/*.js \
    translations/*.ts \
    qml/images

OTHER_FILES += \
    rpm/$${TARGET}.spec

SAILFISHAPP_ICONS = 86x86 256x256 172x172 128x128 108x108

CONFIG += sailfishapp_i18n
CONFIG += sailfishapp_i18n_idbased

TRANSLATIONS += \
    translations/harbour-pwdhash.ts \
    translations/harbour-pwdhash-ca.ts \
    translations/harbour-pwdhash-cs.ts \
    translations/harbour-pwdhash-de.ts \
    translations/harbour-pwdhash-en.ts \
    translations/harbour-pwdhash-es.ts \
    translations/harbour-pwdhash-fr.ts \
    translations/harbour-pwdhash-hr.ts \
    translations/harbour-pwdhash-ko.ts \
    translations/harbour-pwdhash-nl.ts \
    translations/harbour-pwdhash-pl.ts \
    translations/harbour-pwdhash-pt.ts \
    translations/harbour-pwdhash-ro.ts \
    translations/harbour-pwdhash-ru.ts \
    translations/harbour-pwdhash-tr.ts \
    translations/harbour-pwdhash-vi.ts \
    translations/harbour-pwdhash-zh.ts
