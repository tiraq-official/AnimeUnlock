import QtQuick 2.11

//
// IconButton — a bare icon that highlights on hover. Used inside the password
// bar (the reference design shows plain icons there, not circled buttons).
//
Item {
    id: button
    property string iconName: "power"
    property color  iconColor: root.cText
    signal clicked()

    Rectangle {
        anchors.centerIn: parent
        width:  Math.min(parent.width, parent.height)
        height: width
        radius: width / 2
        color: area.containsMouse ? Qt.rgba(1, 1, 1, 0.16) : "transparent"
        Behavior on color { ColorAnimation { duration: 120 } }
    }

    Icon {
        anchors.centerIn: parent
        width:  Math.min(parent.width, parent.height) * 0.52
        height: width
        name: button.iconName
        color: area.containsMouse ? root.cAccent : button.iconColor
        Behavior on color { ColorAnimation { duration: 120 } }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
    }
}
