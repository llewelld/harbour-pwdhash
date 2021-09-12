/*
  Copyright (C) 2014 Robert Gerlach <khnz@gmx.de>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

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

import QtQuick 2.0
import Sailfish.Silica 1.0
import uk.co.flypig.pwdhash 1.0

import "hashed-password.js" as HashedPassword
import "domain-history.js" as DomainHistory

Page {
    id: page
    allowedOrientations: Orientation.All

    property bool nonalphanumeric
    property int size
    property string randomstring
    property int stabilised
    property bool delayedCopy
    property bool updateWhenActive
    property int passwordStrength: digest.checkPasswordStrength(appwin.password)

    function copyPassword() {
        if (appwin.hash) {
            if (digest.running) {
                delayedCopy = true
            }
            else {
                Clipboard.text = appwin.hash
                DomainHistory.store(appwin.domain)
                if (!AppSettings.autoClose && appwin.applicationActive) {
                    //% "Copied"
                    Notices.show(qsTrId("mainpage-nt-password_copied"), Notice.Short, Notice.Bottom)
                }
            }
            if (AppSettings.autoClose && appwin.applicationActive) {
                appwin.deactivate()
            }
        }
    }

    function updateRequired() {
        if (status == PageStatus.Active) {
            updateWhenActive = false
            updateHash()
        }
        else {
            updateWhenActive = true
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Active && updateWhenActive) {
            updateWhenActive = false
            updateHash()
        }
    }

    Connections {
        target: AppSettings
        onCamSaltChanged: updateRequired()
        onCamIterationsChanged: updateRequired()
    }

    Digest {
        id: digest

        onResultChanged: {
          var constrained = HashedPassword.applyConstraints(result, size, nonalphanumeric);
          appwin.hash = constrained
          if (delayedCopy) {
              delayedCopy = false
              copyPassword()
          }
        }
        onRunningChanged: {
          if (!running) {
            stabilise.start()
          }
        }
    }

    Timer {
        interval: 50
        repeat: true
        running: digest.running || stabilised < size
        onTriggered: {
            var characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456+/'
            var string = ""
            for (var count = 0; count < size; count++) {
                var pos = Math.floor(Math.random() * characters.length)
                string += characters[pos]
            }
            randomstring = string
        }
    }

    NumberAnimation on stabilised {
      id: stabilise
      to: size
      duration: size * 100
      easing.type: Easing.Linear
    }

    function updateHash() {
        var hashedPassword = ""
        if (appwin.domain && appwin.password) {
            stabilised = 0
            stabilise.stop()
            size = appwin.password.length + 2
            if (inputHashType.currentIndex == 0) {
                digest.md5Input(appwin.password, appwin.domain)
            }
            else {
                var password = appwin.password + AppSettings.camSalt
                digest.pbkdf2Input(password, appwin.domain, AppSettings.camIterations, (2 * size / 3) + 16)
            }

            nonalphanumeric = appwin.password.match(/\W/) !== null;
        }
        else {
            size = 0
            appwin.hash = ""
            stabilised = 0;
            stabilise.stop()
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTrId("about")
                onClicked: pageStack.push(Qt.resolvedUrl('AboutPage.qml'))
            }
            MenuItem {
                text: qsTrId("settings")
                onClicked: pageStack.push(Qt.resolvedUrl('SettingsPage.qml'))
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTrId("app_name")
            }

            SiteAddressHistory {
                id: inputSiteAddress
                width: parent.width

                label: qsTrId("address")
                placeholderText: label

                onTextChanged: {
                    appwin.domain = (text) ? HashedPassword.extractDomain(text) : "";
                    updateHash()
                }

                onEnterkey: {
                    inputSitePassword.forceActiveFocus()
                }
            }

            TextField {
                id: inputSitePassword
                width: parent.width - passwordStrength.width

                label: qsTrId("password")
                placeholderText: label

                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-clipboard"
                EnterKey.onClicked: {
                    focus = false
                    copyPassword()
                }

                onTextChanged: {
                    appwin.password = (text) ? HashedPassword.extractPassword(text) : ""
                    updateHash()
                }

                rightItem: GlassItem {
                    height: Theme.iconSizeSmallPlus
                    width: height
                    color: {
                        var colours = ["darkred", "red", "orange", "orange", "lawngreen"]
                        return appwin.password ? colours[passwordStrength] : "transparent"
                    }
                    Behavior on color {
                        ColorAnimation { duration: 250 }
                    }
                    falloffRadius: 0.25
                    radius: 0.15
                    cache: false
                }
            }

            MouseArea {
                width: parent.width
                height: hashText.height + hashLabel.height + 3 * Theme.paddingSmall
                property bool down: pressed && containsMouse && !pressDelayTimer.running
                opacity: hashText.text ? 1 : 0
                Behavior on opacity { FadeAnimator {}}

                onClicked: copyPassword()

                Timer {
                    id: pressDelayTimer
                    interval: 48
                    running: parent.pressed
                }

                Label {
                    id: hashText
                    y: Theme.paddingSmall
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * x - rightItem.width
                    color: Theme.highlightColor
                    font.family: "Monospace"
                    truncationMode: TruncationMode.Fade

                    text: appwin.hash.substring(0, stabilised) + randomstring.substring(stabilised, size)
                }

                IconButton {
                    id: rightItem
                    width: icon.width + 2 * Theme.paddingMedium
                    height: icon.height
                    anchors.verticalCenter: hashText.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.horizontalPageMargin
                    highlighted: down || parent.down

                    onClicked: copyPassword()

                    icon.source: "image://theme/icon-s-clipboard"
                }

                Label {
                    id: hashLabel
                    anchors.top: hashText.bottom
                    anchors.topMargin: Theme.paddingSmall
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * x
                    text: qsTrId("hash")
                    font.pixelSize: Theme.fontSizeSmall
                    color: parent.down ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }
            }

            ComboBox {
                id: inputHashType
                //% "Hash type"
                label: qsTrId("hash_type");
                currentIndex: AppSettings.hashType

                onCurrentIndexChanged: {
                    AppSettings.hashType = currentIndex
                    updateHash()
                }

                menu: ContextMenu {
                    //% "Stanford"
                    MenuItem { text: qsTrId("settingspage-cb-hashtype_stanford") }
                    //% "Cambridge"
                    MenuItem { text: qsTrId("settingspage-cb-hashtype_cambridge") }
                }
            }
        }
    }

    function applicationActiveChanged(active) {
        if (active) {
            if ((inputSitePassword.text.length > 0) || (inputSiteAddress.text.length == 0))
                inputSiteAddress.forceActiveFocus()
            else
                inputSitePassword.forceActiveFocus()
        }
    }
}
