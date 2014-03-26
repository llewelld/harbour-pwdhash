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

CoverBackground {
    id: cover

    CoverPlaceholder {
        id: placeholder
        icon.source: "../../icons/hicolor/86x86/apps/harbour-pwdhash.png"
        text: (appwin.domain) ? "" : "pwdhash"
    }

    Column {
        y: 2*Theme.paddingLarge + placeholder.icon.height + (appwin.show_hash ? 0 : Theme.paddingLarge)
        x: Theme.paddingMedium
        width: cover.width - 2*x
        spacing: Theme.paddingSmall

        Label {
            visible: appwin.domain.length > 0
            text: "Domain:"
            color: Theme.secondaryColor
            font.pixelSize: (appwin.show_hash) ? Theme.fontSizeTiny : Theme.fontSizeSmall
            width: parent.width
        }

        Label {
            visible: appwin.domain.length > 0
            text: appwin.domain
            color: Theme.primaryColor
            wrapMode: Text.NoWrap
            font.pixelSize: (appwin.show_hash) ? Theme.fontSizeSmall : Theme.fontSizeMedium
            fontSizeMode: Text.Fit
            width: parent.width
        }

        Label {
            visible: appwin.show_hash
            text: "Password:"
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeTiny
            width: parent.width
        }

        Label {
            visible: appwin.show_hash
            text: appwin.hash
            color: Theme.primaryColor
            wrapMode: Text.NoWrap
            font.pixelSize: Theme.fontSizeSmall
            fontSizeMode: Text.Fit
            width: parent.width
        }

    }

    CoverActionList {
        enabled: appwin.hash != ""

        CoverAction {
            iconSource: "image://theme/icon-camera-flash-redeye"
            onTriggered: {
                appwin.show_hash = !appwin.show_hash
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-l-copy"
            onTriggered: {
                Clipboard.text = appwin.hash
            }
        }
    }

}
