//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray

ShellRoot {
    id: root

    property string windowTitle: ""
    readonly property var sinkAudio: Pipewire.defaultAudioSink?.audio
    property string volumeText: sinkAudio == null ? "  --%  " : (sinkAudio.muted ? "  " : `  ${Math.round(sinkAudio.volume * 100)}%  `)
    property string networkText: "Not connected"
    property string cpuText: "/ C ---%"
    property string memoryText: "/ M ---%"
    property string batteryText: "  --%"
    property string clockText: ""

    readonly property color barBg: Qt.rgba(0, 0, 0, 0.20)
    readonly property color pillBg: "#ffffff"
    readonly property color textDark: "#000000"
    readonly property color textLight: "#ffffff"

    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int barFontSize: 12
    readonly property int barIconFontSize: 14
    readonly property int launcherFontSize: 12
    readonly property int launcherFooterFontSize: 10
    readonly property int statModuleWidth: 58

    property var apps: []

    function parseDesktopApps(text) {
        const parsed = []
        for (const line of text.split("\n")) {
            if (!line.trim()) continue
            const parts = line.split("\t")
            if (parts.length < 3) continue
            parsed.push({ name: parts[0], icon: parts[1], exec: parts.slice(2).join("\t") })
        }
        root.apps = parsed
    }

    function appIconSource(icon) {
        if (!icon) return ""
        if (icon.startsWith("/")) return icon
        return Quickshell.iconPath(icon, true)
    }

    function launchDesktopExec(execLine) {
        const cmd = execLine
            .replace(/%[fFuUdDnNickvm]/g, "")
            .replace(/@@u|@@/g, "")
            .trim()
        if (!cmd) return
        appLaunchProc.command = ["sh", "-c", cmd + " >/dev/null 2>&1 &"]
        appLaunchProc.running = true
    }

    function runPowerCommand(cmd) {
        powerMenu.visible = false
        powerProc.command = ["sh", "-c", cmd]
        powerProc.startDetached()
    }

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }


    function updateClock() {
        clockText = Qt.formatDateTime(new Date(), "hh:mm:ss")
    }

    function refreshFast() {
        if (!cpuProc.running) cpuProc.running = true
        if (!memoryProc.running) memoryProc.running = true
        if (!batteryProc.running) batteryProc.running = true
    }

    function refreshSlow() {
        if (!networkProc.running) networkProc.running = true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.updateClock()
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshFast()
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshSlow()
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activewindow" || event.name === "activewindowv2") {
                if (!windowProc.running) windowProc.running = true
            }
        }
    }

    Process {
        id: windowProc
        running: true
        command: ["sh", "-c", "hyprctl activewindow 2>/dev/null | awk -F': ' '/^[[:space:]]*title:/ {print $2; exit}' | sed -E 's/(.*) - Brave$/\\1/; s/(.*) - Chromium$/\\1/; s/(.*) - Outlook$/\\1/; s/(.*) Microsoft Teams$/\\1/' | cut -c1-70"]
        stdout: StdioCollector {
            id: windowOut
            onStreamFinished: root.windowTitle = windowOut.text.trim()
        }
    }

    Process {
        id: networkProc
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE,CONNECTION dev 2>/dev/null | awk -F: 'BEGIN { found=0 } $2==\"connected\" { found=1; if ($1==\"wifi\") { print \"  \" $3; exit } if ($1==\"ethernet\") { print \"󰈀  \" $3; exit } } END { if (!found) print \"Not connected\" }'"]
        stdout: StdioCollector {
            id: networkOut
            onStreamFinished: root.networkText = networkOut.text.trim() || "Not connected"
        }
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "LC_ALL=C top -bn1 | awk -F'[, ]+' '/Cpu/ { printf \"/ C %3.0f%%\", 100 - $8 }'"]
        stdout: StdioCollector {
            id: cpuOut
            onStreamFinished: root.cpuText = cpuOut.text.trim() || "/ C ---%"
        }
    }

    Process {
        id: memoryProc
        command: ["sh", "-c", "free | awk '/Mem:/ { printf \"/ M %3.0f%%\", $3 / $2 * 100 }'"]
        stdout: StdioCollector {
            id: memoryOut
            onStreamFinished: root.memoryText = memoryOut.text.trim() || "/ M ---%"
        }
    }

    Process {
        id: batteryProc
        command: ["sh", "-c", "cap=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1); status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1); [ -z \"$cap\" ] && exit 0; icon=; [ $cap -ge 80 ] && icon=; [ $cap -ge 60 ] && [ $cap -lt 80 ] && icon=; [ $cap -ge 40 ] && [ $cap -lt 60 ] && icon=; [ $cap -ge 20 ] && [ $cap -lt 40 ] && icon=; [ \"$status\" = Charging ] && icon=󰓦; printf \"%s %s%%\" \"$icon\" \"$cap\""]
        stdout: StdioCollector {
            id: batteryOut
            onStreamFinished: root.batteryText = batteryOut.text.trim() || "  --%"
        }
    }

    Process {
        id: appLoadProc
        running: true
        command: ["sh", "-c", "find /run/current-system/sw/share/applications /etc/profiles/per-user/$USER/share/applications $HOME/.local/share/applications -name '*.desktop' 2>/dev/null | while IFS= read -r f; do awk 'BEGIN{name=icon=exec=\"\"; nodisplay=hidden=0} /^Name=/ && name==\"\" {name=substr($0,6)} /^Icon=/ && icon==\"\" {icon=substr($0,6)} /^Exec=/ && exec==\"\" {exec=substr($0,6)} /^NoDisplay=true/ {nodisplay=1} /^Hidden=true/ {hidden=1} END { if (name != \"\" && exec != \"\" && !nodisplay && !hidden) { gsub(/\t/, \" \", name); gsub(/\t/, \" \", icon); gsub(/\t/, \" \", exec); print name \"\t\" icon \"\t\" exec } }' \"$f\"; done | sort -u"]
        stdout: StdioCollector {
            id: appLoadOut
            onStreamFinished: root.parseDesktopApps(appLoadOut.text)
        }
    }

    Process { id: appLaunchProc }
    Process { id: powerProc }

    IpcHandler {
        target: "launcher"

        function open(): void {
            launcher.visible = true
            Qt.callLater(() => search.forceActiveFocus())
        }

        function close(): void {
            launcher.visible = false
        }

        function toggle(): void {
            launcher.visible = !launcher.visible
            if (launcher.visible) Qt.callLater(() => search.forceActiveFocus())
        }
    }
    Process { id: pavuProc; command: ["pavucontrol"] }
    Process { id: nmtuiProc; command: ["kitty", "-e", "nmtui"] }
    Process { id: htopProc; command: ["kitty", "-e", "htop"] }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true }
            implicitHeight: 50
            exclusiveZone: 50
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                color: root.barBg

                Item {
                    anchors.fill: parent

                    // Left: custom/appmenu + active window, like Waybar modules-left.
                    RowLayout {
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Rectangle {
                            Layout.preferredHeight: 28
                            Layout.preferredWidth: appText.implicitWidth + 20
                            radius: 14
                            color: "transparent"

                            Text {
                                id: appText
                                anchors.centerIn: parent
                                text: "Apps"
                                color: root.textLight
                                font.family: root.fontFamily
                                font.bold: true
                                font.pixelSize: root.barFontSize
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    launcher.visible = !launcher.visible
                                    if (launcher.visible) Qt.callLater(() => search.forceActiveFocus())
                                }
                            }
                        }

                        Text {
                            Layout.maximumWidth: 520
                            elide: Text.ElideRight
                            text: root.windowTitle
                            color: root.textLight
                            font.family: root.fontFamily
                            font.pixelSize: root.barFontSize
                        }
                    }

                    // Center: true screen-centered hyprland/workspaces.
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 3

                        Repeater {
                            model: 5

                            Rectangle {
                                required property int index
                                property int ws: index + 1
                                property bool active: Hyprland.focusedWorkspace != null && Hyprland.focusedWorkspace.id === ws

                                Layout.preferredHeight: 28
                                Layout.preferredWidth: active ? 50 : 26
                                radius: 14
                                color: active ? root.pillBg : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: parent.ws
                                    color: parent.active ? root.textDark : root.textLight
                                    font.family: root.fontFamily
                                    font.bold: true
                                    font.pixelSize: root.barFontSize
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Hyprland.dispatch("workspace " + parent.ws)
                                }
                            }
                        }
                    }

                    // Right modules: audio/network/cpu/memory/battery/clock/tray/exit.
                    RowLayout {
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        PillText {
                            text: root.volumeText
                            onClicked: pavuProc.startDetached()
                        }

                        PillText {
                            text: root.networkText
                            onClicked: nmtuiProc.startDetached()
                        }

                        TextModule {
                            text: root.cpuText
                            onClicked: htopProc.startDetached()
                        }

                        TextModule {
                            text: root.memoryText
                            onClicked: htopProc.startDetached()
                        }

                        PillText { text: root.batteryText }

                        PillText { text: root.clockText }

                        RowLayout {
                            spacing: 10
                            Repeater {
                                model: SystemTray.items
                                Image {
                                    required property var modelData
                                    Layout.preferredWidth: 18
                                    Layout.preferredHeight: 18
                                    source: modelData.icon
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                        }

                        Text {
                            text: ""
                            color: root.textLight
                            font.family: root.fontFamily
                            font.pixelSize: root.barIconFontSize

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: powerMenu.visible = !powerMenu.visible
                            }
                        }
                    }
                }
            }

        }
    }

    PanelWindow {
                id: launcher
                screen: Quickshell.screens[0]
                anchors { top: true; left: true; right: true; bottom: true }
                exclusiveZone: 0
                visible: false
                color: "transparent"
                focusable: true
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

                onVisibleChanged: {
                    if (visible) Qt.callLater(() => search.forceActiveFocus())
                    else launcher.query = ""
                }

                property string query: ""
                property var filteredApps: root.apps.filter(app => app.name.toLowerCase().includes(query.toLowerCase())).slice(0, 100)

                function launchCurrent() {
                    if (filteredApps.length === 0) return
                    const app = filteredApps[Math.max(0, appList.currentIndex)]
                    if (!app) return
                    root.launchDesktopExec(app.exec)
                    launcher.visible = false
                    launcher.query = ""
                    search.text = ""
                }

                Rectangle {
                    width: 600
                    height: 560
                    anchors.centerIn: parent
                    radius: 16
                    color: "#111111"
                    border.color: "#ffffff"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 10

                        TextField {
                            id: search
                            Layout.fillWidth: true
                            Layout.preferredHeight: 38
                            placeholderText: "Search apps..."
                            text: launcher.query
                            focus: true
                            activeFocusOnTab: true
                            selectByMouse: true
                            color: root.textLight
                            placeholderTextColor: "#aaaaaa"
                            font.family: root.fontFamily
                            font.pixelSize: root.launcherFontSize
                            onTextChanged: {
                                launcher.query = text
                                appList.currentIndex = 0
                            }
                            Keys.onEscapePressed: launcher.visible = false
                            Keys.onDownPressed: {
                                if (appList.count > 0) appList.currentIndex = Math.min(appList.currentIndex + 1, appList.count - 1)
                                appList.positionViewAtIndex(appList.currentIndex, ListView.Contain)
                            }
                            Keys.onUpPressed: {
                                if (appList.count > 0) appList.currentIndex = Math.max(appList.currentIndex - 1, 0)
                                appList.positionViewAtIndex(appList.currentIndex, ListView.Contain)
                            }
                            Keys.onReturnPressed: launcher.launchCurrent()
                            Keys.onEnterPressed: launcher.launchCurrent()

                            background: Rectangle {
                                radius: 12
                                color: "#222222"
                                border.color: "#444444"
                            }
                        }

                        ListView {
                            id: appList
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 4
                            model: launcher.filteredApps
                            currentIndex: 0

                            delegate: Rectangle {
                                required property var modelData
                                width: appList.width
                                height: 46
                                radius: 12
                                property bool selected: appMouse.containsMouse || ListView.isCurrentItem
                                color: selected ? "#ffffff" : "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    spacing: 12

                                    Image {
                                        Layout.preferredWidth: 28
                                        Layout.preferredHeight: 28
                                        source: root.appIconSource(modelData.icon)
                                        fillMode: Image.PreserveAspectFit
                                        visible: source !== ""
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.name
                                        elide: Text.ElideRight
                                        color: parent.parent.selected ? root.textDark : root.textLight
                                        font.family: root.fontFamily
                                        font.pixelSize: root.launcherFontSize
                                    }
                                }

                                MouseArea {
                                    id: appMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.launchDesktopExec(modelData.exec)
                                        launcher.visible = false
                                        launcher.query = ""
                                        search.text = ""
                                    }
                                }
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: launcher.filteredApps.length + " apps"
                            color: "#888888"
                            font.family: root.fontFamily
                            font.pixelSize: root.launcherFooterFontSize
                        }
                    }
                }
            }

    PanelWindow {
        id: powerMenu
        screen: Quickshell.screens[0]
        anchors { top: true; left: true; right: true; bottom: true }
        exclusiveZone: 0
        visible: false
        color: "transparent"
        focusable: true
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.35)

            MouseArea {
                anchors.fill: parent
                onClicked: powerMenu.visible = false
            }

            Rectangle {
                width: 360
                height: 220
                anchors.centerIn: parent
                radius: 16
                color: "#111111"
                border.color: "#ffffff"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    Text {
                        Layout.fillWidth: true
                        text: "Power Menu"
                        color: root.textLight
                        font.family: root.fontFamily
                        font.pixelSize: root.launcherFontSize + 2
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    PowerMenuButton {
                        label: "  Shutdown"
                        command: "systemctl poweroff"
                    }

                    PowerMenuButton {
                        label: "󰜉  Restart"
                        command: "systemctl reboot"
                    }

                    PowerMenuButton {
                        label: "󰍃  Logout"
                        command: "hyprctl dispatch exit"
                    }
                }
            }
        }
    }

    component PowerMenuButton: Rectangle {
        id: btn
        property string label: ""
        property string command: ""

        Layout.fillWidth: true
        Layout.preferredHeight: 42
        radius: 12
        color: btnMouse.containsMouse ? root.pillBg : "#222222"

        Text {
            anchors.centerIn: parent
            text: btn.label
            color: btnMouse.containsMouse ? root.textDark : root.textLight
            font.family: root.fontFamily
            font.pixelSize: root.launcherFontSize
            font.bold: true
        }

        MouseArea {
            id: btnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.runPowerCommand(btn.command)
        }
    }

    component PillText: Rectangle {
        id: pill
        property alias text: label.text
        signal clicked()

        Layout.preferredHeight: 28
        Layout.preferredWidth: label.implicitWidth + 20
        Layout.rightMargin: 10
        radius: 12
        color: "transparent"

        Text {
            id: label
            anchors.centerIn: parent
            color: root.textLight
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: root.barFontSize
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: pill.clicked()
        }
    }

    component TextModule: Text {
        id: txt
        signal clicked()
        color: root.textLight
        Layout.preferredWidth: root.statModuleWidth
        horizontalAlignment: Text.AlignLeft
        font.family: root.fontFamily
        font.pixelSize: root.barFontSize
        font.bold: false

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: txt.clicked()
        }
    }
}
