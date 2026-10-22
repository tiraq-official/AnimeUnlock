import QtQuick 2.11
import QtGraphicalEffects 1.0

//
// RoundImage — circular crop of an arbitrary image (e.g. a user's ~/.face).
// It is loaded through a Loader so that, on a system without
// QtGraphicalEffects (or Qt5Compat.GraphicalEffects), only this small piece
// fails and the rest of the theme keeps working.
//
Item {
    id: round
    property alias source:   img.source
    property alias fillMode: img.fillMode

    Image {
        id: img
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize: Qt.size(Math.max(1, Math.round(width)), Math.max(1, Math.round(height)))
        visible: false
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        radius: width / 2
        visible: false
    }

    OpacityMask {
        anchors.fill: parent
        source: img
        maskSource: mask
    }
}
