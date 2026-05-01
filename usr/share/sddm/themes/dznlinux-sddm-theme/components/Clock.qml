/*
 *   Copyright 2016 David Edmundson <davidedmundson@kde.org>
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
import QtQuick.Layouts

import org.kde.plasma.clock as PlasmaClock
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

ColumnLayout {
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software

    PlasmaComponents3.Label {
        text: Qt.formatTime(timeSource.dateTime)
        color: Kirigami.Theme.textColor
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? Kirigami.Theme.backgroundColor : "transparent"
        font.pointSize: 48
        Layout.alignment: Qt.AlignHCenter
    }
    PlasmaComponents3.Label {
        text: Qt.formatDate(timeSource.dateTime, Qt.DefaultLocaleLongDate)
        color: Kirigami.Theme.textColor
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? Kirigami.Theme.backgroundColor : "transparent"
        font.pointSize: 24
        Layout.alignment: Qt.AlignHCenter
    }

    PlasmaClock.Clock {
        id: timeSource
        trackSeconds: true
    }
}
