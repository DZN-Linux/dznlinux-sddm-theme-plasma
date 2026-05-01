import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2

import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami

PlasmaComponents.ToolButton {
    id: keyboardButton

    property int currentIndex: -1

    text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Keyboard Layout: %1", instantiator.objectAt(currentIndex) ? instantiator.objectAt(currentIndex).shortName : "")
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    font.pointSize: config.fontSize

    visible: keyboardMenu.count > 1

    Component.onCompleted: currentIndex = Qt.binding(function() { return keyboard.currentLayout })

    onClicked: keyboardMenu.popup(keyboardButton, 0, keyboardButton.height)

    QQC2.Menu {
        id: keyboardMenu
        Instantiator {
            id: instantiator
            model: keyboard.layouts
            onObjectAdded: (index, object) => keyboardMenu.insertItem(index, object)
            onObjectRemoved: (index, object) => keyboardMenu.removeItem(object)
            delegate: QQC2.MenuItem {
                text: modelData.longName
                property string shortName: modelData.shortName
                onTriggered: {
                    keyboard.currentLayout = model.index
                    keyboardButton.currentIndex = model.index
                }
            }
        }
    }
}
