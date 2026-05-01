/*
 *   Copyright 2016 Kai Uwe Broulik <kde@privat.broulik.de>
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

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.workspace.components as PW
import org.kde.plasma.private.battery
import org.kde.kirigami as Kirigami

RowLayout {
    spacing: Kirigami.Units.smallSpacing
    visible: batteryControl.hasInternalBatteries

    BatteryControlModel {
        id: batteryControl
    }

    PW.BatteryIcon {
        pluggedIn: batteryControl.pluggedIn
        hasBattery: batteryControl.hasCumulative
        percent: batteryControl.percent

        Layout.preferredHeight: Math.max(Kirigami.Units.iconSizes.medium, batteryLabel.implicitHeight)
        Layout.preferredWidth: Layout.preferredHeight
        Layout.alignment: Qt.AlignVCenter
    }

    PlasmaComponents3.Label {
        id: batteryLabel
        font.pointSize: config.fontSize
        text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "%1%", batteryControl.percent)
        Accessible.name: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Battery at %1%", batteryControl.percent)
        Layout.alignment: Qt.AlignVCenter
    }
}
