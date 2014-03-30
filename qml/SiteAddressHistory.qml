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
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0

import "domain-extractor.js" as DomainExtractor

Item {
    id: item

    property alias text: textField.text
    property int maxSearchResults: 5

    signal enterkey

    function store() {
        listModel.store()
    }

    width: parent.width
    height: textField.height + listView.height

    TextField {
        id: textField

        width: parent.width

        label: "site address"
        placeholderText: label

        text: appwin.domain
        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase

        EnterKey.enabled: text.length > 0
        EnterKey.iconSource: "image://theme/icon-m-enter-next"
        EnterKey.onClicked: item.enterkey()

        onTextChanged: listModel.update()
        onFocusChanged: focus ? listModel.update() : listModel.hide()
    }

    Rectangle {
        anchors.fill: listView
        color: "black"
        opacity: 0.2
    }

    SilicaListView {
        id: listView
        visible: textField.activeFocus

        width: parent.width
        height: 0
        anchors.top: textField.bottom

        model: ListModel {
            id: listModel

            property var _database
            property var _domain

            function _getDatabase() {
                if (!_database) {
                    _database = LocalStorage.openDatabaseSync("history", "1.0", "Description", 100000);
                    _database.transaction(function(tx){
                        tx.executeSql("CREATE TABLE IF NOT EXISTS domains(domain TEXT PRIMARY KEY, counter INTEGER DEFAULT 0)");
                    });
                }
                return _database;
            }

            function update() {
                _domain = textField.text ? DomainExtractor.extractDomain(textField.text) : ""

                clear()

                var db = _getDatabase();
                if (db) {
                    db.readTransaction(function(tx){
                        var result = tx.executeSql(
                                    "SELECT domain FROM domains " +
                                    "WHERE domain LIKE ? AND domain <> ?" +
                                    "ORDER BY counter DESC " +
                                    "LIMIT ?",
                                    [ _domain+'%', _domain, maxSearchResults ]);

                        listView.height = result.rows.length * Theme.itemSizeSmall;
                        for (var i=0; i<result.rows.length; i++) {
                            append({ name: result.rows.item(i).domain });
                        }
                    });
                }
            }

            function store() {
                console.log("store2")
                if ((textField.acceptableInput) && (_domain.length > 3)) {
                    var db = _getDatabase();
                    if (db) {
                        db.transaction(function(tx){
                            var result = tx.executeSql("UPDATE domains SET counter=counter+1 WHERE domain=?", [_domain]);
                            if (result.rowsAffected == 0)
                                tx.executeSql("INSERT OR IGNORE INTO domains (domain,counter) VALUES (?,?)", [_domain, 1]);
                        });
                    }
                }
            }

            function hide() {
                listView.height = 0
            }

        }

        delegate: ListItem {
            width: parent.width
            height: Theme.itemSizeSmall

            Label {
                text: name

                width: parent.width
                anchors {
                    left: parent.left; leftMargin: Theme.paddingLarge
                    right: parent.right; rightMargin: Theme.paddingLarge
                    verticalCenter: parent.verticalCenter
                }
            }

            onClicked: {
                textField.text = name
                item.enterkey()
            }
        }

    }
}
