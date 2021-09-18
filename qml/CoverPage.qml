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

CoverBackground {
    id: cover

    Image {
        id: background
        visible: true
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: sourceSize.height * width / sourceSize.width
        source: AppSettings.getImageUrl("cover-background")
        opacity: 0.1
    }

    Column {
        x: Theme.paddingLarge
        y: Theme.paddingLarge
        width: cover.width - 2 * x
        spacing: Theme.paddingLarge

        Label {
            color: Theme.highlightColor
            //% "PwdHash"
            text: qsTrId("cover_la_title")
            fontSizeMode: Text.VerticalFit
            font.pixelSize: Theme.fontSizeLarge
            wrapMode: Text.Wrap
            width: parent.width
            elide: Text.ElideNone
            maximumLineCount: 3
        }

        Column {
            width: parent.width
            spacing: Theme.paddingSmall

            Label {
                visible: appwin.domain.length > 0
                //% "Domain"
                text: qsTrId("cover-la-domain")
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width
                maximumLineCount: 4
            }

            Label {
                visible: appwin.domain.length > 0
                text: appwin.domain.split('.').join('.\n')
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
                width: parent.width
            }
        }
    }

    CoverActionList {
        enabled: appwin.hash != ""

        CoverAction {
            iconSource: AppSettings.getImageUrl("icon-cover-action-hash")
            onTriggered: {
                appwin.mainPage.pasteDomain = true
                activate()
            }
        }

        CoverAction {
            iconSource: AppSettings.getImageUrl("icon-cover-action-clipboard")
            onTriggered: {
                Clipboard.text = appwin.hash
            }
        }
    }

    CoverActionList {
        enabled: appwin.hash == ""

        CoverAction {
            iconSource: AppSettings.getImageUrl("icon-cover-action-hash")
            onTriggered: {
                appwin.mainPage.pasteDomain = true
                activate()
            }
        }
    }
}
