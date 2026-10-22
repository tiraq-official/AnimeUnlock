import QtQuick 2.11
import QtGraphicalEffects 1.0

//
// Frost5 — frosted-glass backdrop for Qt 5 (module: QtGraphicalEffects).
// Frost6.qml is the identical twin for Qt 6, which renamed the module to
// Qt5Compat.GraphicalEffects. FrostedBackdrop.qml loads whichever works.
//
// It captures the wallpaper region sitting behind the pill, blurs it, and
// clips the result to the pill's rounded shape. The capture is deliberately
// larger than the pill so the blur has real pixels to chew on at the edges.
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
