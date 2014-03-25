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

import "domain-extractor.js" as DomainExtractor
import "password-extractor.js" as PasswordExtractor
import "hashed-password.js" as HashedPassword

Page {
    id: mainpage

    function _update_hash() {
        var hashedPassword = "";
        if (appwin.domain && appwin.password)
            hashedPassword = HashedPassword.getHashedPassword(appwin.password, appwin.domain);
        appwin.hash = hashedPassword;
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column

            width: mainpage.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "PwdHash"
            }

            TextField {
                id: inputSiteAddress
                width: parent.width
                label: "site address"
                placeholderText: label
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase
                focus: true;

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: inputSitePassword.focus = true

                onTextChanged: {
                    appwin.domain = (text) ? DomainExtractor.extractDomain(text) : "";
                    _update_hash();
                }
            }

            TextField {
                id: inputSitePassword
                width: parent.width
                label: "site password"
                placeholderText: label
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: PwdHash.copy_hashed_password()

                onTextChanged: {
                    appwin.password = (text) ? PasswordExtractor.extractPassword(text) : "";
                    _update_hash();
                }
            }

            TextField {
                id: inputHashedPassword
                width: parent.width
                label:  "hashed password (tap to copy)"
                text: appwin.hash
                color: Theme.highlightColor
                readOnly: true

                onClicked: {
                    if (appwin.hash) { selectAll(); copy(); }
                }
            }

        }
    }

}
