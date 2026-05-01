/*
 *   Copyright 2014 David Edmundson <davidedmundson@kde.org>
 *   Copyright 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick
import Qt5Compat.GraphicalEffects
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Item {
    id: wrapper

    // If we're using software rendering, draw outlines instead of shadows
    // See https://bugs.kde.org/show_bug.cgi?id=398317
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software

    property bool isCurrent: true

    readonly property var m: model
    property string name
    property string userName
    property string avatarPath
    property string iconSource
    property bool constrainText: true
    property alias nameFontSize: usernameDelegate.font.pointSize
    property int fontSize: config.fontSize
    signal clicked()

    property real faceSize: Math.min(width, height - usernameDelegate.height - Kirigami.Units.smallSpacing)

    opacity: isCurrent ? 1.0 : 0.5

    Behavior on opacity {
        OpacityAnimator {
            duration: Kirigami.Units.longDuration
        }
    }

    // Draw a translucent background circle under the user picture
    Rectangle {
        anchors.centerIn: avatarContainer
        width: avatarContainer.width - 2 // Subtract to prevent fringing
        height: width
        radius: width / 2

        color: Kirigami.Theme.backgroundColor
        opacity: 0.6
    }

    // Avatar container with circular clipping via OpacityMask
    Item {
        id: avatarContainer
        anchors {
            bottom: usernameDelegate.top
            bottomMargin: Kirigami.Units.largeSpacing
            horizontalCenter: parent.horizontalCenter
        }
        Behavior on width {
            PropertyAnimation {
                from: faceSize
                duration: Kirigami.Units.longDuration * 2;
            }
        }
        width: isCurrent ? faceSize : faceSize - Kirigami.Units.largeSpacing
        height: width

        Item {
            id: imageSource
            anchors.fill: parent
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: imageSource.width
                    height: imageSource.height
                    radius: width / 2
                }
            }

            Image {
                id: face
                source: wrapper.avatarPath
                sourceSize: Qt.size(faceSize, faceSize)
                fillMode: Image.PreserveAspectCrop
                anchors.fill: parent
            }

            Kirigami.Icon {
                id: faceIcon
                source: iconSource
                visible: (face.status == Image.Error || face.status == Image.Null)
                anchors.fill: parent
                anchors.margins: Kirigami.Units.gridUnit * 0.5
                color: Kirigami.Theme.textColor
            }
        }

        // Antialiased circular border overlay
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "transparent"
            border.color: Kirigami.Theme.textColor
            border.width: 2
            antialiasing: true
        }
    }

    PlasmaComponents.Label {
        id: usernameDelegate
        font.pointSize: Math.max(fontSize + 2, Kirigami.Theme.defaultFont.pointSize + 2)
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        height: implicitHeight // work around stupid bug in Plasma Components that sets the height
        width: constrainText ? parent.width : implicitWidth
        text: wrapper.name
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? Kirigami.Theme.backgroundColor : "transparent"
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        //make an indication that this has active focus, this only happens when reached with keyboard navigation
        font.underline: wrapper.activeFocus
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: wrapper.clicked();
    }

    Accessible.name: name
    Accessible.role: Accessible.Button
    function accessiblePressAction() { wrapper.clicked() }
}
