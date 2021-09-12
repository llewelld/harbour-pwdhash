#include <qdebug.h>

#include <openssl/evp.h>
#include <openssl/hmac.h>

#include "zxcvbn.h"
#include "digest.h"

static const int TYPING_DELAY = 250;

Digest::Digest(QObject * parent)
    : QObject(parent)
    , m_running(false)
    , m_working(false)
    , m_pending(false)
    , m_resultType(HashTypePbkdf2Sha256)
    , m_generate(HashTypePbkdf2Sha256)
{
    m_timer.setInterval(TYPING_DELAY);
    m_timer.setSingleShot(true);

    Worker * worker = new Worker();
    worker->moveToThread(&m_workerThread);
    connect(&m_workerThread, &QThread::finished, worker, &QObject::deleteLater);
    connect(this, &Digest::operatePbkdf2Sha256, worker, &Worker::doWorkPbkdf2Sha256);
    connect(this, &Digest::operateMd5, worker, &Worker::doWorkMd5);
    connect(worker, &Worker::resultReady, this, &Digest::updateResult);
    connect(&m_timer, &QTimer::timeout, this, &Digest::timerCompleted);
    m_workerThread.start();

    qRegisterMetaType<HashType>();
}

Digest::~Digest()
{
    m_workerThread.quit();
    m_workerThread.wait();
}

void Digest::pbkdf2Input(QString password, QString realm, int iterations, int size)
{
    m_password = password;
    m_realm = realm;
    m_iterations = iterations;
    m_size = size;
    m_generate = HashTypePbkdf2Sha256;

    runTimer();
}

void Digest::md5Input(QString password, QString realm)
{
    m_password = password;
    m_realm = realm;
    m_generate = HashTypeMd5;

    runTimer();
}

void Digest::runTimer()
{
    m_timer.start();
    if (!m_running) {
        m_running = true;
        emit runningChanged();
    }
}

bool Digest::running()
{
    return m_running;
}

QString Digest::result()
{
    return m_result;
}

Digest::HashType Digest::resultType()
{
    return m_resultType;
}

void Digest::runOperation()
{
    m_working = true;
    switch (m_generate) {
    case HashTypePbkdf2Sha256:
        operatePbkdf2Sha256(m_password, m_realm, m_iterations, m_size);
        break;
    case HashTypeMd5:
        operateMd5(m_password, m_realm);
        break;
    }
}

void Digest::timerCompleted()
{
    if (!m_working) {
        runOperation();
    }
    else {
        m_pending = true;
    }
}

void Digest::updateResult(const QString &result, Digest::HashType resultType)
{
    bool typeChanged = (resultType != m_resultType);

    m_result = result;
    m_working = false;
    m_resultType = resultType;

    if (m_pending) {
        runOperation();
    }
    else {
        m_running = false;
        emit runningChanged();
    }

    if (typeChanged) {
        emit resultTypeChanged();
    }

    emit resultChanged();
}

int Digest::checkPasswordStrength(QString password)
{
    double entropy;
    int strength;
    entropy = ZxcvbnMatch(password.toLatin1().data(), nullptr, nullptr);

    double log = entropy * 0.301029996;
    if (log < 3) {
        strength = 0;
    }
    else if (log < 6) {
        strength = 1;
    }
    else if (log < 8) {
        strength = 2;
    }
    else if (log < 10) {
        strength = 3;
    }
    else {
        strength = 4;
    }
    return strength;
}

void Worker::doWorkPbkdf2Sha256(const QString &password, const QString &realm, int iterations, int size)
{
    QByteArray out;
    out.fill('x', size);
    int success = PKCS5_PBKDF2_HMAC(password.toLatin1().data(), password.length(),
                          (unsigned char *)realm.toLatin1().data(), realm.length(), iterations,
                          EVP_sha256(),
                          size, (unsigned char *)out.data());
    QString result;
    if (success == 1) {
        result = out.toBase64();
    }
    emit resultReady(result, Digest::HashTypePbkdf2Sha256);
}

void Worker::doWorkMd5(const QString &password, const QString &realm)
{
    QByteArray out;
    out.fill(' ', EVP_MAX_MD_SIZE);
    unsigned int length = EVP_MAX_MD_SIZE;

    HMAC(EVP_md5(), password.toLatin1().data(), password.length(),
                  (unsigned char *)realm.toLatin1().data(), realm.length(),
                  (unsigned char *)out.data(), &length);

    out.truncate(length);
    QString result;
    result = out.toBase64();
    emit resultReady(result, Digest::HashTypeMd5);
}

