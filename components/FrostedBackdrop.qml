import QtQuick 2.11

//
// FrostedBackdrop — drop this behind a pill's background rectangle.
//
// It loads the Qt 5 or Qt 6 implementation of the blur, whichever the running
// greeter can provide (see Main.qml). If neither is available — or if
// PillFrost is turned off in theme.conf — nothing is drawn and the pill just
// keeps its plain translucent fill.
//
Item {
    id: backdrop
    property Item sourceItem: null
    property rect sourceRect: Qt.rect(0, 0, 0, 0)
    property real cornerRadius: height / 2
    property real blurRadius: 40

    Loader {
        id: impl
        anchors.fill: parent
        active: root.pillFrost && root.frostQml !== ""
        source: root.frostQml
        onLoaded: {
            impl.item.sourceItem   = Qt.binding(function() { return backdrop.sourceItem; });
            impl.item.sourceRect   = Qt.binding(function() { return backdrop.sourceRect; });
            impl.item.cornerRadius = Qt.binding(function() { return backdrop.cornerRadius; });
            impl.item.blurRadius   = Qt.binding(function() { return backdrop.blurRadius; });
        }
    }
}
