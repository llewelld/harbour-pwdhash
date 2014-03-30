TARGET = harbour-pwdhash

CONFIG += sailfishapp

SOURCES += \
    src/main.cpp

OTHER_FILES += \
    rpm/harbour-pwdhash.yaml \
    harbour-pwdhash.desktop \
    harbour-pwdhash.svg \
    harbour-pwdhash.png \
    qml/main.qml \
    qml/MainPage.qml \
    qml/SiteAddressHistory.qml \
    qml/CoverPage.qml \
    qml/md5.js \
    qml/domain-extractor.js \
    qml/password-extractor.js \
    qml/hashed-password.js
