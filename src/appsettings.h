#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QObject>
#include <QSettings>

class QQmlEngine;
class QJSEngine;

class AppSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool autoClose READ autoClose WRITE setAutoClose NOTIFY autoCloseChanged)

    Q_PROPERTY(int camIterations READ camIterations WRITE setCamIterations NOTIFY camIterationsChanged)
    Q_PROPERTY(QString camSalt READ camSalt WRITE setCamSalt NOTIFY camSaltChanged)
    Q_PROPERTY(int hashType READ hashType WRITE setHashType NOTIFY hashTypeChanged)

public:
    explicit AppSettings(QObject *parent = nullptr);
    ~AppSettings();

    static void instantiate(QObject *parent = nullptr);
    static AppSettings &getInstance();
    static QObject *provider(QQmlEngine *engine, QJSEngine *scriptEngine);

    // Constant image properties
    Q_INVOKABLE QString getImageDir() const;
    Q_INVOKABLE QString getImageUrl(QString const &id) const;

    // Get properties
    bool autoClose() const;
    int camIterations() const;
    QString camSalt() const;
    int hashType() const;

    // Set properties
    void setAutoClose(bool autoclose);
    void setCamIterations(int camIterations);
    void setCamSalt(QString const &camSalt);
    void setHashType(int hashtype);

signals:
    // Notify property changes
    void autoCloseChanged();
    void camIterationsChanged();
    void camSaltChanged();
    void hashTypeChanged();

private:
    static AppSettings *instance;
    QSettings *m_settings;
    QString m_imageDir;
};

#endif // APPSETTINGS_H
