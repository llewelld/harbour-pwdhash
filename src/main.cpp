/*
  Copyright (C) 2014 Robert Gerlach <khnz@gmx.de>
  All rights reserved.

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QTranslator>
#include <QObject>
#include <QDebug>

#include "digest.h"
#include "appsettings.h"
#include "version.h"

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

int main(int argc, char *argv[])
{
    QGuiApplication *app = SailfishApp::application(argc, argv);
    QCoreApplication::setOrganizationDomain("www.flypig.co.uk");
    QCoreApplication::setOrganizationName("harbour-pwdhash");
    QCoreApplication::setApplicationName("harbour-pwdhash");

    qDebug() << "Contrac version" << VERSION;

    AppSettings::instantiate(app);

    QTranslator *translator = new QTranslator();
    QString qmdir = SailfishApp::pathTo(QString("translations")).toLocalFile();
    if(!translator->load(QLocale::system(), "", "", qmdir))
        translator->load(QLocale(QLocale::English), "", "", qmdir);
    app->installTranslator(translator);

    qmlRegisterType<Digest>("uk.co.flypig.pwdhash", 1, 0, "Digest");
    qmlRegisterSingletonType<AppSettings>("uk.co.flypig.pwdhash", 1, 0, "AppSettings", AppSettings::provider);

    QQuickView *view = SailfishApp::createView();
    view->setSource(SailfishApp::pathTo("qml/main.qml"));
    QQmlContext *ctxt = view->rootContext();
    ctxt->setContextProperty("version", VERSION);
    view->show();

    int result = app->exec();

    qDebug() << "Execution finished:" << result;
    delete view;
    qDebug() << "Deleted view";
    delete app;
    qDebug() << "Deleted app";

    return result;
}
