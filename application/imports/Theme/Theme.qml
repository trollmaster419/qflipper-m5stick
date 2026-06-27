pragma Singleton

import QtQuick 2.15

import QFlipper 1.0

QtObject {
    id: theme

    // Selected accent palette name (persisted in Preferences). The accent
    // family below switches with it. NOTE: the multicolor device illustration
    // SVGs (flipper body, d-pad, on-screen dolphin) are baked assets and do
    // not follow this setting.
    readonly property string palette: Preferences.colorPalette

    // Accent families. Index order:
    // [light1, light2(main), light3, dark1, dark2, med1, med2, med3, med4, med5]
    readonly property var _families: {
        "amber":  ["#ff9722", "#fe8a2c", "#ce5300", "#491d00", "#3a1f10", "#9e5823", "#76380b", "#662c00", "#9b450b", "#9e4a12"],
        "purple": ["#7d3fc9", "#6a1bb3", "#4b1289", "#1c0636", "#180a28", "#43217a", "#2e1257", "#260e49", "#3a1675", "#3d1a78"],
        "green":  ["#3fc95a", "#1bb33d", "#128943", "#06361a", "#0a2814", "#217a3a", "#125730", "#0e4928", "#167535", "#1a7838"],
        "blue":   ["#3f8fc9", "#1b6ab3", "#124b89", "#061c36", "#0a1828", "#21437a", "#122e57", "#0e2649", "#163a75", "#1a3d78"]
    }

    readonly property var _accent: _families[palette] !== undefined ? _families[palette] : _families["purple"]

    readonly property var color: QtObject {
        readonly property color transparent: Qt.rgba(0, 0, 0, 0)

        readonly property color lightorange1: theme._accent[0]
        readonly property color lightorange2: theme._accent[1]
        readonly property color lightorange3: theme._accent[2]
        readonly property color darkorange1: theme._accent[3]
        readonly property color darkorange2: theme._accent[4]
        readonly property color mediumorange1: theme._accent[5]
        readonly property color mediumorange2: theme._accent[6]
        readonly property color mediumorange3: theme._accent[7]
        readonly property color mediumorange4: theme._accent[8]
        readonly property color mediumorange5: theme._accent[9]

        readonly property color lightgreen: "#2ed832"
        readonly property color mediumgreen1: "#285b12"
        readonly property color mediumgreen2: "#203812"
        readonly property color darkgreen: "#0c160c"

        readonly property color lightblue: "#228cff"
        readonly property color mediumblue: "#143c66"
        readonly property color darkblue1: "#11355c"
        readonly property color darkblue2: "#152b47"

        readonly property color lightred1: "#ff5b27"
        readonly property color lightred2: "#ff5924"
        readonly property color lightred3: "#ff1f00"
        readonly property color lightred4: "#ff3c00"
        readonly property color mediumred1: "#953618"
        readonly property color mediumred2: "#672715"
        readonly property color darkred1: "#451a0e"
        readonly property color darkred2: "#331400"
    }

    readonly property var timing: QtObject {
        readonly property int toolTipDelay: 500
    }
}
