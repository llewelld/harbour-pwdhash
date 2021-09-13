TEMPLATE = app
TARGET = harbour-pwdhash
CONFIG += sailfishapp

PKGCONFIG += \
    openssl \
    mlite5

SOURCES = \
    appsettings.cpp \
    digest.cpp \
    main.cpp \
    zxcvbn.cpp

HEADERS = \
    appsettings.h \
    digest.h \
    version.h \
    zxcvbn.h \
    dict-src.h

OTHER_FILES = \
    qml/*.qml \
    qml/*.js \
    qml/SettingsPage.qml \
    qml/domain-history.js
