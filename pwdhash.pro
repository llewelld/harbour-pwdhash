TARGET = pwdhash

CONFIG += sailfishapp

SOURCES += \
    src/main.cpp

OTHER_FILES += qml/pwdhash.qml \
    rpm/pwdhash.spec \
    rpm/pwdhash.yaml \
    pwdhash.desktop \
    qml/scripts/md5.js \
    qml/scripts/hashed-password.js \
    qml/scripts/domain-extractor.js \
    qml/scripts/password-extractor.js \
    qml/pwdhash.js \
    qml/cover/main.qml \
    qml/pages/MainPage.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pwdhash.js \
    qml/password-extractor.js \
    qml/md5.js \
    qml/hashed-password.js \
    qml/domain-extractor.js \
    qml/pwdhash.js \
    qml/password-extractor.js \
    qml/md5.js \
    qml/hashed-password.js \
    qml/domain-extractor.js \
    qml/pwdhash.qml \
    qml/MainPage.qml \
    qml/CoverPage.qml

HEADERS += \
    src/pwdhash.h

