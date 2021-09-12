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

import "domain-history.js" as DomainHistory

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                //% "Settings"
                title: qsTrId("settingspage-ph-settings")
            }

            SectionHeader {
                //% "General settings"
                text: qsTrId("settingspage-sh-general_settings")
            }

            TextSwitch {
                width: parent.width
                //% "Auto close"
                text: qsTrId("settingspage-ts-auto_close")
                checked: AppSettings.autoClose
                automaticCheck: false
                onClicked: AppSettings.autoClose = !checked
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //% "Clear history"
                text: qsTrId("settingspage-bt-clear_history")
                //% "History cleared"
                onClicked: Remorse.popupAction(page, qsTrId("settingspage-rt-clear_sure"), DomainHistory.clear)
            }

            SectionHeader {
                //% "Cambridge PwdHash settings"
                text: qsTrId("settingspage-sh-cambridge")
            }

            TextField {
                id: saltField
                width: parent.width

                //% "Salt"
                label: qsTrId("settingspage-tf-salt")
                placeholderText: label
                text: AppSettings.camSalt

                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: iterationsField.focus = true

                onTextChanged: AppSettings.camSalt = text
            }

            TextField {
                id: iterationsField
                width: parent.width

                //% "Iterations"
                label: qsTrId("settingspage-tf-iterations")
                placeholderText: label
                text: AppSettings.camIterations
                validator: RegExpValidator { regExp: /^[0-9]*$/ }

                inputMethodHints: Qt.ImhDigitsOnly

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false

                onTextChanged: AppSettings.camIterations = parseInt(text)
            }
        }
    }
}
