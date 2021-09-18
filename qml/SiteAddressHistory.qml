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

import "domain-history.js" as DomainHistory

Item {
    id: item

    property alias text: textField.text
    property alias label: textField.label
    property alias placeholderText: textField.placeholderText

    signal enterkey

    function forceActiveFocus() {
        textField.forceActiveFocus()
    }

    width: parent.width
    height: textField.height + listView.height

    TextField {
        id: textField

        width: parent.width

        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase

        EnterKey.enabled: text.length > 0
        EnterKey.iconSource: "image://theme/icon-m-enter-next"
        EnterKey.onClicked: item.enterkey()

        onTextChanged: listModel.update()
        onFocusChanged: if (focus) { listModel.show(); selectAll() } else { listModel.hide() }

        rightItem: IconButton {
            onClicked: textField.text = ""

            width: icon.width
            height: icon.height
            icon.source: "image://theme/icon-splus-clear"
            opacity: textField.text.length > 0 ? 1.0 : 0.0
            Behavior on opacity { FadeAnimation {} }
        }
    }

    Rectangle {
        anchors.fill: listView
        color: "black"
        opacity: 0.2
    }

    SilicaListView {
        id: listView

        width: parent.width
        height: 0
        anchors.top: textField.bottom

        model: ListModel {
            id: listModel

            function _update() {
                var a = textField.text.split('/');
                while ((a.length > 0) && ((!a[0]) || (a[0].substr(-1) == ':')))
                    a.shift();
                if (a.length == 0)
                    return;
                a = a[0].split('.');
                for (var i=0; i<a.length; i++)
                    a[i] = a.slice(i).join('.');

                for (var i=0; i<a.length; i++) {
                    var result = DomainHistory.search(a[i]);
                    if (result && result.length > 0) {
                        for (var i=0; i<result.length; i++)
                            append({ name: result[i] });
                        break;
                    }
                }

            }

            function update() {
                clear();
                _update();
                listView.height = listModel.count * Theme.itemSizeSmall;
            }

            function show() {
                update();
                listView.visible = true;
            }

            function hide() {
                clear();
                listView.height = 0;
                listView.visible = false;
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
