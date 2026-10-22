import QtQuick 2.11

//
// WeatherPill — the small frosted pill in the top-right corner.
// Its text comes from theme.conf (WeatherText). SDDM has no network access,
// so this is a static label you can set to whatever you like.
//
Item {
    id: pill
    property real u: 1
    property rect frostRect: Qt.rect(0, 0, 0, 0)

    implicitWidth: row.implicitWidth + root.s(30)
    implicitHeight: root.s(42)
    width: implicitWidth
    height: implicitHeight

    FrostedBackdrop {
        anchors.fill: parent
        sourceItem: bgLayer
        sourceRect: pill.frostRect
        cornerRadius: pill.height / 2
        blurRadius: root.pillBlur
    }

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: root.cGlass
        border.color: root.cStroke
        border.width: 1
    }

    Row {
        id: row
        anchors.centerIn: parent
        height: pill.height
        spacing: root.s(9)

        Icon {
            width: root.s(19)
            height: row.height
            name: "weather"
            color: root.cText
        }

        Text {
            height: row.height
            text: root.weatherText
            color: root.cText
            font.family: root.fontFamily
            font.pixelSize: root.s(16)
            font.letterSpacing: root.s(0.5)
            verticalAlignment: Text.AlignVCenter
        }
    }
}
