#include <mlite5/MGConfItem>
#include <sailfishapp.h>
#include <QDebug>
#include <QGuiApplication>
#include <QStandardPaths>

#include "appsettings.h"

AppSettings *AppSettings::instance = nullptr;

AppSettings::AppSettings(QObject *parent)
    : QObject(parent)
{
    QString filename = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/" + QCoreApplication::applicationName() + ".conf";
    qDebug() << "Config path:" << filename;
    m_settings = new QSettings(filename, QSettings::NativeFormat, this);

    // Figure out where we're going to find our images
    QScopedPointer<MGConfItem> ratioItem(new MGConfItem("/desktop/sailfish/silica/theme_pixel_ratio"));
    double pixelRatio = ratioItem->value(1.0).toDouble();

    double const threshold[] = {1.75, 1.5, 1.25, 1.0};
    QString const dir[] = {"2.0", "1.75", "1.5", "1.25", "1.0"};

    Q_ASSERT((sizeof(dir) / sizeof(QString)) == ((sizeof(threshold) / sizeof(double)) + 1));

    qDebug() << "Pixel ration: " << pixelRatio;
    size_t pos;
    for (pos = 0; pos < (sizeof(threshold) - 1) && pixelRatio <= threshold[pos]; ++pos) {
        // Just carry on looping
    }

    m_imageDir = SailfishApp::pathTo("qml/images/z" + dir[pos]).toString(QUrl::RemoveScheme) + "/";
    qDebug() << "Image folder: " << m_imageDir;
}

AppSettings::~AppSettings()
{
    m_settings->sync();
    delete m_settings;
    instance = nullptr;
    qDebug() << "Deleted settings: " << m_settings->status();
}

void AppSettings::instantiate(QObject *parent)
{
    if (instance == nullptr) {
        instance = new AppSettings(parent);
    }
}

AppSettings &AppSettings::getInstance()
{
    return *instance;
}

QObject *AppSettings::provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return instance;
}

QString AppSettings::getImageDir() const
{
    return m_imageDir;
}

QString AppSettings::getImageUrl(QString const &id) const
{
    return m_imageDir + id + ".png";
}

// Get properties
bool AppSettings::autoClose() const
{
    qDebug() << "Get autoClose: " << m_settings->value(QStringLiteral("application/autoClose"), false).toBool();
    return m_settings->value(QStringLiteral("application/autoClose"), false).toBool();
}

int AppSettings::camIterations() const
{
    return m_settings->value(QStringLiteral("cambridge/iterations"), 1000).toInt();
}

QString AppSettings::camSalt() const
{
    return m_settings->value(QStringLiteral("cambridge/salt"), QStringLiteral("ChangeMe")).toString();
}

int AppSettings::hashType() const
{
    return m_settings->value(QStringLiteral("application/hashType"), 0).toInt();
}

// Set properties
void AppSettings::setAutoClose(bool autoclose)
{
    qDebug() << "Set autoClose from: " << m_settings->value(QStringLiteral("application/autoClose"), false).toBool();
    qDebug() << "Set autoClose to: " << autoclose;
    if (autoclose != m_settings->value(QStringLiteral("application/autoClose"), false).toBool()) {
        qDebug() << "Set autoClose: setting";
        m_settings->setValue(QStringLiteral("application/autoClose"), autoclose);
        emit autoCloseChanged();
    }
}

void AppSettings::setCamIterations(int camIterations)
{
    if (camIterations != this->camIterations()) {
        m_settings->setValue(QStringLiteral("cambridge/iterations"), camIterations);
        emit camIterationsChanged();
    }
}

void AppSettings::setCamSalt(QString const &camSalt)
{
    if (camSalt != this->camSalt()) {
        m_settings->setValue(QStringLiteral("cambridge/salt"), camSalt);
        emit camSaltChanged();
    }
}

void AppSettings::setHashType(int hashtype)
{
    if (hashtype != this->hashType()) {
        m_settings->setValue(QStringLiteral("application/hashType"), hashtype);
        emit hashTypeChanged();
    }
}
