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

Page {
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.height

        Column {
            id: column
            width: parent.width - 2*Theme.paddingLarge
            x: Theme.paddingLarge
            spacing: Theme.paddingLarge

            PageHeader {
                //% "About"
                title: qsTrId("aboutpage-ph-about")
            }

            Image {
                id: icon
                source: "../../icons/hicolor/86x86/apps/harbour-pwdhash.png"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                width: parent.width
                //: The %1 will be replaced by a version number
                //% "Version: %1"
                text: qsTrId("aboutpage-la-version").arg(version)
                wrapMode: Text.Wrap
            }

            Label {
                width: parent.width
                //% "Copyright 2014 © Robert Gerlach"
                text: qsTrId("aboutpage-la-copyright_2014")
                wrapMode: Text.Wrap
            }

            Label {
                width: parent.width
                //% "Copyright 2021 © David Llewellyn-Jones"
                text: qsTrId("aboutpage-la-copyright_2021")
                wrapMode: Text.Wrap
            }

            SectionHeader {
                //% "Contributors"
                text: qsTrId("aboutpage-sh-contributors")
            }

            Label {
                width: parent.width
                //% "Includes an implementation of the Stanford PwdHash hashing algorithm. Copyright 2005 © Collin Jackson."
                text: qsTrId("aboutpage-la-stanford_copyright")
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
            }

            Label {
                width: parent.width
                //% "Includes an implementation of the Cambridge PwdHash hashing algorithm. Copyright 2016 © David Llewellyn-Jones, Graham Rymer."
                text: qsTrId("aboutpage-la-cambridge_copyright")
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
            }

            Label {
                width: parent.width
                //% "Includes Tony Evans's MIT-licesed implementation of the zxcvbn password strength algorithm. Copyright © 2015-2017 Tony Evans."
                text: qsTrId("aboutpage-la-zxcvbn-c-copyright")
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
            }

            Label {
                width: parent.width
                //% "Other contributors: Dan Boneh, John Mitchell, Nick Miyake, Blake Ross"
                text: qsTrId("aboutpage-la-other_contributors")
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
            }

            SectionHeader {
                //% "License"
                text: qsTrId("aboutpage-sh-license")
            }

            Label {
                width: parent.width
                //% "This software is distributed under the BSD License. See LICENSE for details."
                text: qsTrId("aboutpage-la-license_bsd")
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                wrapMode: Text.Wrap
            }

            SectionHeader {
                //% "Links"
                text: qsTrId("aboutpage-sh-links")
            }

            Row {
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    //% "Website"
                    text: qsTrId("aboutpage-bt-website_link")
                    onClicked: Qt.openUrlExternally("https://openrepos.net/content/khnz/pwdhash")
                }
                Button {
                    //% "Source code"
                    text: qsTrId("aboutpage-bt-github_link")
                    onClicked: Qt.openUrlExternally("http://github.com/khnz/harbour-pwdhash")
                }
            }
        }

        VerticalScrollDecorator {}
    }
}
