/********************************************************************
 This file is part of the KDE project.

Copyright (C) 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************/

import QtQuick
import QtQuick.Effects
import org.kde.kirigami as Kirigami

Item {
    id: wallpaperFader
    property Item clock
    property Item mainStack
    property Item footer
    property alias source: wallpaperEffect.source
    property real factor: 0
    readonly property bool lightBackground: Math.max(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b) > 0.5

    Behavior on factor {
        NumberAnimation {
            target: wallpaperFader
            property: "factor"
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }

    // MultiEffect replaces FastBlur + ShaderEffect color matrix from Qt5
    MultiEffect {
        id: wallpaperEffect
        anchors.fill: parent

        blurEnabled: true
        blur: wallpaperFader.factor * 1.0
        blurMax: 64

        saturation: wallpaperFader.factor * 0.6
        brightness: (wallpaperFader.lightBackground ? 0.35 : -0.2) * wallpaperFader.factor
        contrast: wallpaperFader.factor * -0.2
    }

    states: [
        State {
            name: "on"
            PropertyChanges {
                target: mainStack
                opacity: 1
            }
            PropertyChanges {
                target: footer
                opacity: 1
            }
            PropertyChanges {
                target: wallpaperFader
                factor: 1
            }
            PropertyChanges {
                target: clock.shadow
                opacity: 0
            }
        },
        State {
            name: "off"
            PropertyChanges {
                target: mainStack
                opacity: 0
            }
            PropertyChanges {
                target: footer
                opacity: 0
            }
            PropertyChanges {
                target: wallpaperFader
                factor: 0
            }
            PropertyChanges {
                target: clock.shadow
                opacity: 1
            }
        }
    ]
    transitions: [
        Transition {
            from: "off"
            to: "on"
            //Note: can't use animators as they don't play well with parallelanimations
            ParallelAnimation {
                NumberAnimation {
                    target: mainStack
                    property: "opacity"
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: footer
                    property: "opacity"
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        },
        Transition {
            from: "on"
            to: "off"
            ParallelAnimation {
                NumberAnimation {
                    target: mainStack
                    property: "opacity"
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: footer
                    property: "opacity"
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }
    ]
}
