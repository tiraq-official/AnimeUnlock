import QtQuick 2.11

//
// Clock — big time and the date underneath, top-left corner.
//
Item {
    id: clock
    property real u: 1
    property var  now: new Date()

    width:  column.implicitWidth
    height: column.implicitHeight

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: clock.now = new Date()
    }

    Column {
        id: column
        spacing: root.s(0)

        Text {
            text: Qt.formatTime(clock.now, "HH:mm")
            color: root.cText
            font.family: root.fontFamily
            font.weight: Font.Bold
            font.pixelSize: root.s(150)
            font.letterSpacing: root.s(3)
            style: Text.Raised
            styleColor: Qt.rgba(0, 0, 0, 0.10)
        }

        Text {
            text: Qt.formatDate(clock.now, "dddd, d MMMM")
            color: root.cTextDim
            font.family: root.monoFamily
            font.pixelSize: root.s(28)
            font.letterSpacing: root.s(1)
        }
    }
}
