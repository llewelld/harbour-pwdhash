#ifndef DIGEST_H
#define DIGEST_H

#include <QObject>
#include <QTimer>
#include <QThread>

class Digest : public QObject
{
    Q_OBJECT

    Q_ENUMS(HashType)
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(QString result READ result NOTIFY resultChanged)
    Q_PROPERTY(HashType resultType READ resultType NOTIFY resultTypeChanged)

public:
    enum HashType
    {
        HashTypePbkdf2Sha256,
        HashTypeMd5
    };

    Digest(QObject * parent = nullptr);
    ~Digest();

    Q_INVOKABLE void pbkdf2Input(QString password, QString realm, int iterations, int size);
    Q_INVOKABLE void md5Input(QString password, QString realm);
    Q_INVOKABLE int checkPasswordStrength(QString password);

    bool running();
    QString result();
    HashType resultType();

private slots:
    void timerCompleted();
    void updateResult(const QString &result, Digest::HashType resultType);

signals:
    void runningChanged();
    void resultChanged();
    void resultTypeChanged();
    void operatePbkdf2Sha256(const QString &password, const QString &realm, int iterations, int size);
    void operateMd5(const QString &password, const QString &realm);

private:
    void runTimer();
    void runOperation();

public:
    QString m_password;
    QString m_realm;
    int m_iterations;
    int m_size;
    bool m_running;
    bool m_working;
    bool m_pending;
    HashType m_resultType;
    HashType m_generate;

    QString m_result;

    QTimer m_timer;
    QThread m_workerThread;
};

class Worker : public QObject
{
    Q_OBJECT

public slots:
    void doWorkPbkdf2Sha256(const QString &password, const QString &realm, int iterations, int size);
    void doWorkMd5(const QString &password, const QString &realm);

signals:
    void resultReady(const QString &result, Digest::HashType resultType);
};

Q_DECLARE_METATYPE(Digest::HashType)

#endif // DIGEST_H
