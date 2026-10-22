import QtQuick 2.11

//
// PowerButtons — the circled suspend / reboot / power cluster shown in the
// bottom-right corner of the idle screen.
//
Item {
    id: cluster
    property real u: 1
    property real d: root.s(48)

    implicitWidth:  row.implicitWidth
    implicitHeight: d
    width:  implicitWidth
    height: implicitHeight

    Row {
        id: row
        anchors.centerIn: parent
        height: cluster.d
        spacing: root.s(14)

        Repeater {
            model: [
                { glyph: "moon",    ok: root.canSuspend,  action: "suspend" },
                { glyph: "restart", ok: root.canReboot,   action: "reboot"  },
                { glyph: "power",   ok: root.canPowerOff, action: "poweroff" }
            ]

            delegate: Item {
                width: cluster.d
                height: cluster.d
                visible: modelData.ok

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: mouse.containsMouse ? Qt.rgba(1, 1, 1, 0.22) : root.cGlass
                    border.color: root.cStroke
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 120 } }
                }

                Icon {
                    anchors.centerIn: parent
                    width: parent.width * 0.42
                    height: width
                    name: modelData.glyph
                    color: root.cText
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (modelData.action === "suspend")       sddm.suspend();
                        else if (modelData.action === "reboot")   sddm.reboot();
                        else                                      sddm.powerOff();
                    }
                }
            }
        }
    }
}
