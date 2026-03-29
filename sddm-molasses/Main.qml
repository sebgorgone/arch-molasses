import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 640
    height: 480
    color: "#151515"

    property string currentUser: userModel.lastUser
    property int sessionIndex: {
        for (var i = 0; i < sessionModel.rowCount(); i++) {
            var name = (sessionModel.data(sessionModel.index(i, 0), Qt.DisplayRole) || "").toString()
            if (name.indexOf("uwsm") !== -1)
                return i
        }
        return sessionModel.lastIndex
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errorMessage.text = "Login failed"
            password.text = ""
            password.focus = true
        }
        function onLoginSucceeded() {
            errorMessage.text = ""
        }
    }

    // Use a single Column as the vertical container
    Column {
        id: mainColumn
        anchors.centerIn: parent       // vertical + horizontal centering
        spacing: root.height * 0.04
        width: root.width * 0.4        // restrict column width to avoid full width

	// Logo
        Image {
            id: logo
            source: "arch-molasses-logo.png"
            width: parent.width         // scale logo relative to column width
            height: width * (sourceSize.height / sourceSize.width)
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
	    anchors.horizontalCenterOffset: -75
        }

        // Password box
        Rectangle {
            id: loginBox
            width: parent.width / 2
            height: root.height * 0.05
	    anchors.horizontalCenter: parent.horizontalCenter
            color: "#202020"
            border.color: "#515151"
            border.width: 1
            radius: 4
            clip: true

            TextInput {
                id: password
                anchors.fill: parent
                anchors.margins: 8
                verticalAlignment: TextInput.AlignVCenter
                echoMode: TextInput.Password
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: root.height * 0.02
                font.letterSpacing: root.height * 0.004
                passwordCharacter: "\u2022"
                color: "#ffffff"
                focus: true

                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(root.currentUser, password.text, root.sessionIndex)
                        event.accepted = true
                    }
                }
            }
        }

        // Error message
        Text {
            id: errorMessage
            text: ""
            color: "#f7768e"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: root.height * 0.018
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Component.onCompleted: password.forceActiveFocus()
}
