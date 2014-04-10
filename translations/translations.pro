TEMPLATE = aux
TARGET = harbour-pwdhash

LANGUAGES = ca cs de en es fr hr ko nl pl pt ro ru tr vi zh

TRANSLATION_SOURCES += \
    $${_PRO_FILE_PWD_}/../src/qml

for(lang,LANGUAGES): TRANSLATIONS += $${_PRO_FILE_PWD_}/$${lang}.ts

TS_FILE = $${_PRO_FILE_PWD_}/$${TARGET}.ts

update_translations.target = update_translations
update_translations.commands += lupdate $${TRANSLATION_SOURCES} -ts $${TS_FILE} $$TRANSLATIONS

QMAKE_EXTRA_TARGETS += update_translations
PRE_TARGETDEPS += update_translations

tsqm.input = TRANSLATIONS
tsqm.output = ${QMAKE_FILE_BASE}.qm
tsqm.variable_out = PRE_TARGETDEPS
tsqm.commands = lrelease -idbased ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
tsqm.CONFIG = no_link

QMAKE_EXTRA_COMPILERS += tsqm

qm.files = $${OUT_PWD}/*.qm
qm.path = /usr/share/$${TARGET}/translations
qm.CONFIG += no_check_exist

INSTALLS += qm

OTHER_FILES += \
    *.ts
