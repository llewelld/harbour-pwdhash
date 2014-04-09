TEMPLATE = aux
TARGET = harbour-pwdhash

TRANSLATIONS +=

TRANSLATION_SOURCES += \
    $${_PRO_FILE_PWD_}/../src/qml

TS_FILE = $${_PRO_FILE_PWD_}/$${TARGET}.ts

# The target would really be $$TS_FILE, but we use a non-file target to emulate .PHONY
update_translations.target = update_translations
update_translations.commands += mkdir -p translations && lupdate $${TRANSLATION_SOURCES} -ts $${TS_FILE} $$TRANSLATIONS
QMAKE_EXTRA_TARGETS += update_translations
PRE_TARGETDEPS += update_translations

build_translations.target = build_translations
build_translations.commands += lrelease $${_PRO_FILE_}

QMAKE_EXTRA_TARGETS += build_translations
POST_TARGETDEPS += build_translations

qm.files = $$replace(TRANSLATIONS, .ts, .qm)
qm.path = /usr/share/$${TARGET}/translations
qm.CONFIG += no_check_exist

INSTALLS += qm

