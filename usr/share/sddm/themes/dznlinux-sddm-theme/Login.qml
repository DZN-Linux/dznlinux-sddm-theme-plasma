import "components"

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

SessionManagementScreen {

    property bool showUsernamePrompt: !showUserList
    property int usernameFontSize
    property string usernameFontColor
    property string lastUserName
    property bool passwordFieldOutlined: config.PasswordFieldOutlined == "true"
    property bool hidePasswordRevealIcon: config.HidePasswordRevealIcon == "false"
    property int visibleBoundary: mapFromItem(passwordRow, 0, 0).y
    onHeightChanged: visibleBoundary = mapFromItem(passwordRow, 0, 0).y + passwordRow.height + Kirigami.Units.smallSpacing

    // Exposed so Main.qml can check if the password field has text (for blockUI)
    property alias mainPasswordBox: passwordBox

    signal loginRequest(string username, string password)

    onShowUsernamePromptChanged: {
        if (!showUsernamePrompt) {
            lastUserName = ""
        }
    }

    function startLogin() {
        var username = showUsernamePrompt ? userNameInput.text : userList.selectedUser
        var password = passwordBox.text

        loginButton.forceActiveFocus();
        loginRequest(username, password);
    }

    PlasmaComponents.TextField {
        id: userNameInput
        Layout.fillWidth: true
        Layout.minimumHeight: 32
        implicitHeight: root.height / 28
        font.family: config.Font || "Noto Sans"
        font.pointSize: usernameFontSize
        opacity: 0.5
        text: lastUserName
        visible: showUsernamePrompt
        focus: showUsernamePrompt && !lastUserName
        placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Username")
        color: "black"
        background: Rectangle {
            radius: 100
            color: "white"
        }
    }

    RowLayout {
        id: passwordRow
        Layout.fillWidth: true
        spacing: 8

        PlasmaComponents.TextField {
            id: passwordBox

            Layout.fillWidth: true
            Layout.minimumHeight: 32
            implicitHeight: usernameFontSize * 2.85
            font.pointSize: usernameFontSize * 0.8
            opacity: passwordFieldOutlined ? 1.0 : 0.5
            font.family: config.Font || "Noto Sans"
            placeholderText: config.PasswordFieldPlaceholderText || i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Password")
            focus: !showUsernamePrompt || lastUserName
            echoMode: TextInput.Password
            passwordCharacter: config.PasswordFieldCharacter || "●"
            onAccepted: startLogin()
            color: passwordFieldOutlined ? "white" : "black"
            background: Rectangle {
                radius: 100
                border.color: "white"
                border.width: 1
                color: passwordFieldOutlined ? "transparent" : "white"
            }

            Keys.onEscapePressed: {
                mainStack.currentItem.forceActiveFocus();
            }

            Keys.onPressed: function(event) {
                if (event.key == Qt.Key_Left && !text) {
                    userList.decrementCurrentIndex();
                    event.accepted = true
                }
                if (event.key == Qt.Key_Right && !text) {
                    userList.incrementCurrentIndex();
                    event.accepted = true
                }
            }

            Keys.onReleased: function(event) {
                if (loginButton.opacity == 0 && length > 0) {
                    showLoginButton.start()
                }
                if (loginButton.opacity > 0 && length == 0) {
                    hideLoginButton.start()
                }
            }

            Connections {
                target: sddm
                function onLoginFailed() {
                    passwordBox.selectAll()
                    passwordBox.forceActiveFocus()
                }
            }
        }

        Image {
            id: loginButton
            source: Qt.resolvedUrl("assets/login.svgz")
            smooth: true
            Layout.preferredWidth: passwordBox.implicitHeight
            Layout.preferredHeight: passwordBox.implicitHeight
            Layout.alignment: Qt.AlignVCenter
            visible: opacity > 0
            opacity: 0
            MouseArea {
                anchors.fill: parent
                onClicked: startLogin();
            }
            PropertyAnimation {
                id: showLoginButton
                target: loginButton
                properties: "opacity"
                to: 0.75
                duration: 100
            }
            PropertyAnimation {
                id: hideLoginButton
                target: loginButton
                properties: "opacity"
                to: 0
                duration: 80
            }
        }
    }
}
