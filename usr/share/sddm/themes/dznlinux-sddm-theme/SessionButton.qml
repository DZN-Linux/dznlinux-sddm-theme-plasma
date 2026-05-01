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
import QtQuick.Controls as QQC2

import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmaComponents.ToolButton {
    id: root
    property int currentIndex: -1

    implicitWidth: implicitContentWidth + leftPadding + rightPadding

    visible: sessionMenu.count > 1

    text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Desktop Session: %1", instantiator.objectAt(currentIndex) ? instantiator.objectAt(currentIndex).text : "")

    font.pointSize: config.fontSize

    Component.onCompleted: {
        currentIndex = sessionModel.lastIndex
    }

    onClicked: sessionMenu.popup(root, 0, root.height)

    QQC2.Menu {
        id: sessionMenu
        Instantiator {
            id: instantiator
            model: sessionModel
            onObjectAdded: (index, object) => sessionMenu.insertItem(index, object)
            onObjectRemoved: (index, object) => sessionMenu.removeItem(object)
            delegate: QQC2.MenuItem {
                text: model.name
                onTriggered: {
                    root.currentIndex = model.index
                }
            }
        }
    }
}
