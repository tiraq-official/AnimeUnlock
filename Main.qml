//
// AnimeUnlock — an SDDM greeter theme
//
// Flow
//   1. Idle screen  : clock + weather, a profile selector on the left,
//                     the "Type your password to unlock" pill in the middle,
//                     a desktop-session selector on the right, and the power
//                     buttons in the bottom-right corner.
//   2. Entry screen : the moment you start typing (or click the pill) the
//                     wallpaper cross-fades to its blurred variant and a
//                     password bar appears, still flanked by the profile and
//                     session selectors, with the power buttons inside it.
//
// Licensed under the GPL-3.0-or-later.
//

import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

import "components"

Rectangle {
    id: root

    // ------------------------------------------------------------- sizing ---
    readonly property real screenW: Screen.width  > 0 ? Screen.width  : 1920
    readonly property real screenH: Screen.height > 0 ? Screen.height : 1080
    readonly property int cfgW: (config.ScreenWidth  && parseInt(config.ScreenWidth)  > 0) ? parseInt(config.ScreenWidth)  : 0
    readonly property int cfgH: (config.ScreenHeight && parseInt(config.ScreenHeight) > 0) ? parseInt(config.ScreenHeight) : 0

    width:  cfgW > 0 ? cfgW : screenW
    height: cfgH > 0 ? cfgH : screenH
    color: "#0b1626"
    focus: true

    property real uiScale: height / 1080
    function s(v) { return v * uiScale }

    // ------------------------------------------------------------ palette ---
    property color cText:        "#ffffff"
    property color cTextDim:     "#d9e6f5"
    property color cGlass:       Qt.rgba(0.055, 0.098, 0.176, 0.55)
    property color cGlassStrong: Qt.rgba(0.035, 0.070, 0.135, 0.74)
    property color cStroke:      Qt.rgba(1, 1, 1, 0.14)
    property color cAccent:      "#a7d4ff"
    property color cDanger:      "#ffb4b4"

    // -------------------------------------------------------------- fonts ---
    property string fontFamily: (config.FontFamily && config.FontFamily !== "") ? config.FontFamily : ""
    property string monoFamily: (config.MonoFontFamily && config.MonoFontFamily !== "") ? config.MonoFontFamily : "monospace"

    // ------------------------------------------------------------- assets ---
    // Qt.resolvedUrl() is important here: without it a relative path is
    // resolved against whichever component file happens to use the value
    // (e.g. components/PasswordBar.qml), not against this file.
    property string bgImage:     Qt.resolvedUrl((config.background     && config.background     !== "") ? config.background     : "assets/background.jpg")
    property string bgBlurImage: Qt.resolvedUrl((config.backgroundBlur && config.backgroundBlur !== "") ? config.backgroundBlur : "assets/background_blur.jpg")
    property string avatarImage: (config.AvatarImage && config.AvatarImage !== "") ? Qt.resolvedUrl(config.AvatarImage) : ""

    // ------------------------------------------------------------ strings ---
    property string promptText:  (config.PromptText && config.PromptText !== "") ? config.PromptText : "Type your password to unlock"
    property string weatherText: config.WeatherText ? config.WeatherText : ""
    property bool   showWeather: config.ShowWeather !== "false"

    // ------------------------------------------------------------- tuning ---
    property real dimAmount:    config.DimBackground ? parseFloat(config.DimBackground) : 0.10
    property int  blurDuration: config.BlurDuration  ? parseInt(config.BlurDuration)   : 320

    // ------------------------------------------------- SDDM capabilities ---
    // Read once here; component files then use root.canSuspend / etc. rather
    // than touching the sddm context property during their first evaluation.
    readonly property bool canSuspend:  (typeof sddm !== "undefined" && sddm !== null) ? sddm.canSuspend  : true
    readonly property bool canReboot:   (typeof sddm !== "undefined" && sddm !== null) ? sddm.canReboot   : true
    readonly property bool canPowerOff: (typeof sddm !== "undefined" && sddm !== null) ? sddm.canPowerOff : true

    // -------------------------------------------------------------- state ---
    property bool   entryMode: false
    property bool   busy: false
    property string errorText: ""
    property real   shakeOffset: 0

    // -------------------------------------------------------------- logic ---
    function enterEntry() {
        if (root.busy) return;
        root.entryMode = true;
        passwordBar.focusPassword();
    }
    function leaveEntry() {
        root.entryMode = false;
        passwordBar.clearPassword();
        root.errorText = "";
        root.forceActiveFocus();
    }
    function submit() {
        if (root.busy) return;
        if (!profile.userName) return;
        root.errorText = "";
        root.busy = true;
        sddm.login(profile.userName, passwordBar.password, session.selIndex);
    }

    // --------------------------------------------------------- background ---
    Image {
        id: bgSharp
        anchors.fill: parent
        source: root.bgImage
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
    }
    Image {
        id: bgBlur
        anchors.fill: parent
        source: root.bgBlurImage
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        opacity: root.entryMode ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: root.blurDuration; easing.type: Easing.InOutQuad } }
    }
    Rectangle {
        anchors.fill: parent
        color: "#04101f"
        opacity: root.entryMode ? Math.min(0.55, root.dimAmount + 0.20) : root.dimAmount
        Behavior on opacity { NumberAnimation { duration: root.blurDuration; easing.type: Easing.InOutQuad } }
    }

    // Clicks on empty space: unlock in idle mode, re-focus (or lock) in entry mode.
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (root.entryMode) {
                if (passwordBar.password.length === 0) root.leaveEntry();
                else passwordBar.focusPassword();
            } else {
                root.enterEntry();
            }
        }
    }

    // -------------------------------------------------------------- clock ---
    Clock {
        id: clock
        u: root.uiScale
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: root.s(56)
    }

    // ------------------------------------------------------------ weather ---
    WeatherPill {
        id: weather
        u: root.uiScale
        visible: root.showWeather && root.weatherText !== ""
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.s(56)
    }

    // -------------------------------------------------- bottom centre row ---
    Item {
        id: bottomRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: root.shakeOffset
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.s(58)
        width:  childrenRect.width
        height: Math.max(profile.height, centreSlot.height, session.height)

        ProfileSelector {
            id: profile
            u: root.uiScale
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            id: centreSlot
            anchors.left: profile.right
            anchors.leftMargin: root.s(18)
            anchors.verticalCenter: parent.verticalCenter
            width:  root.entryMode ? passwordBar.width  : unlockPill.width
            height: root.entryMode ? passwordBar.height : unlockPill.height
            Behavior on width  { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
            Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

            UnlockPill {
                id: unlockPill
                u: root.uiScale
                anchors.centerIn: parent
                opacity: root.entryMode ? 0 : 1
                visible: opacity > 0.01
                onActivated: root.enterEntry()
            }

            PasswordBar {
                id: passwordBar
                u: root.uiScale
                anchors.centerIn: parent
                opacity: root.entryMode ? 1 : 0
                visible: opacity > 0.01
                userName: profile.userName
                userDisplay: profile.userDisplay
                userIcon: profile.userIcon
                onSubmitted: root.submit()
            }
        }

        SessionSelector {
            id: session
            u: root.uiScale
            anchors.left: centreSlot.right
            anchors.leftMargin: root.s(18)
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // ------------------------------------------------------- corner power ---
    PowerButtons {
        id: cornerPower
        u: root.uiScale
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: root.s(56)
        opacity: root.entryMode ? 0 : 1
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    // --------------------------------------------------------- error line ---
    Text {
        id: message
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: bottomRow.top
        anchors.bottomMargin: root.s(18)
        text: root.errorText
        color: root.cDanger
        font.family: root.fontFamily
        font.pixelSize: root.s(18)
        opacity: root.errorText !== "" ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 160 } }
    }

    // --------------------------------------------------------- animations ---
    SequentialAnimation {
        id: shake
        NumberAnimation { target: root; property: "shakeOffset"; to: root.s(-14); duration: 55 }
        NumberAnimation { target: root; property: "shakeOffset"; to: root.s(14);  duration: 55 }
        NumberAnimation { target: root; property: "shakeOffset"; to: root.s(-9);  duration: 55 }
        NumberAnimation { target: root; property: "shakeOffset"; to: root.s(9);   duration: 55 }
        NumberAnimation { target: root; property: "shakeOffset"; to: 0;           duration: 55 }
    }
    Timer { id: errorTimer; interval: 2500; onTriggered: root.errorText = "" }

    // ----------------------------------------------------------- keyboard ---
    Keys.onPressed: {
        if (!root.entryMode) {
            if (event.text.length > 0 && event.text.charCodeAt(0) >= 32 && event.text.charCodeAt(0) !== 127) {
                root.enterEntry();
                passwordBar.appendText(event.text);
                event.accepted = true;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                root.enterEntry();
                event.accepted = true;
            }
        } else if (event.key === Qt.Key_Escape) {
            root.leaveEntry();
            event.accepted = true;
        }
    }

    // ---------------------------------------------------------- sddm hooks ---
    Connections {
        target: sddm
        onLoginSucceeded: { root.busy = false; }
        onLoginFailed: {
            root.busy = false;
            root.errorText = "Incorrect password, try again";
            passwordBar.clearPassword();
            passwordBar.focusPassword();
            shake.restart();
            errorTimer.restart();
        }
    }

    Component.onCompleted: root.forceActiveFocus()
}
