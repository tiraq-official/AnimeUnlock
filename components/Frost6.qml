import QtQuick 2.11
import Qt5Compat.GraphicalEffects

//
// Frost6 — frosted-glass backdrop for Qt 6, where QtGraphicalEffects was
// renamed to Qt5Compat.GraphicalEffects. Body is identical to Frost5.qml.
//
Item {
    id: frost
    property Item sourceItem: null
    property rect sourceRect: Qt.rect(0, 0, 0, 0)
    property real cornerRadius: height / 2
    property real blurRadius: 40

    ShaderEffectSource {
        id: capture
        x: -frost.blurRadius
        y: -frost.blurRadius
        width:  Math.max(1, frost.width  + 2 * frost.blurRadius)
        height: Math.max(1, frost.height + 2 * frost.blurRadius)
        sourceItem: frost.sourceItem
        sourceRect: Qt.rect(frost.sourceRect.x - frost.blurRadius,
                            frost.sourceRect.y - frost.blurRadius,
                            frost.sourceRect.width  + 2 * frost.blurRadius,
                            frost.sourceRect.height + 2 * frost.blurRadius)
        live: true
        visible: false
    }

    FastBlur {
        id: blurred
        x: -frost.blurRadius
        y: -frost.blurRadius
        width:  capture.width
        height: capture.height
        source: capture
        radius: frost.blurRadius
        visible: false
    }

    Item {
        id: maskHolder
        x: -frost.blurRadius
        y: -frost.blurRadius
        width:  capture.width
        height: capture.height
        visible: false

        Rectangle {
            x: frost.blurRadius
            y: frost.blurRadius
            width:  frost.width
            height: frost.height
            radius: frost.cornerRadius
        }
    }

    OpacityMask {
        x: -frost.blurRadius
        y: -frost.blurRadius
        width:  capture.width
        height: capture.height
        source: blurred
        maskSource: maskHolder
    }
}
