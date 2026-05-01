import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import "./Services"

Item {
    id: root

    readonly property color _background: "#1e1e2e00"
    readonly property color _surface_container_low: "#2a2a3e"
    readonly property color _primary: "#89b4fa"
    readonly property color _on_primary: "#1e1e2e"

    // 播放器管理
    property var currentPlayer: MediaManager.active
    readonly property bool playerValid: currentPlayer !== null && currentPlayer !== undefined

    // 时间单位：内部统一使用毫秒
    property double currentPos: 0
    property double totalLength: 0
    property real progress: totalLength > 0 ? currentPos / totalLength : 0
    property string fontfamily: "JetBrainsMono Nerd Font"
    property bool showTranslation: true   // 默认显示翻译

    Connections {
        target: MediaManager
        function onActiveChanged() {
            currentPlayer = MediaManager.active
            updateTimeFromPlayer()
        }
    }

    onCurrentPlayerChanged: {
        if (currentPlayer && currentPlayer.trackTitle)
            triggerLyricsFetch()
        if (currentPlayer) {
            currentPlayer.metadataChanged.connect(triggerLyricsFetch)
            updateTimeFromPlayer()
        }
    }

    // 媒体元数据
    property string artUrl: currentPlayer?.trackArtUrl ?? ""
    property string title: currentPlayer?.trackTitle ?? "未播放"
    property string artist: currentPlayer?.trackArtist ?? "未知艺术家"
    property string album: currentPlayer?.trackAlbum ?? ""
    property bool isPlaying: currentPlayer?.isPlaying ?? false
    property bool showLyrics: false

    Component.onCompleted: {
        if (!currentPlayer && MediaManager.active)
            currentPlayer = MediaManager.active
        updateTimeFromPlayer()
    }

    // 从播放器更新总时长和当前位置（微秒转毫秒）
    function updateTimeFromPlayer() {
        if (currentPlayer) {
            totalLength = (currentPlayer.length || 0) 
            currentPos = (currentPlayer.position || 0)
        } else {
            totalLength = 0
            currentPos = 0
        }
    }

    // ======== 歌词处理 ========
    ListModel { id: lyricsModel }

    function generateMockLyrics() {
        lyricsModel.clear()
        var mockLines = [
            { time: 0, text: "🎵 正在播放：" + title },
            { time: 5000, text: "♪ 暂无同步歌词" },
            { time: 10000, text: "✎ 可配置歌词脚本获得更好体验" },
            { time: 15000, text: "💡 脚本需返回 JSON 数组：[{\"time\":毫秒, \"text\":\"原文\\n译文\"}]\n💡 Script should return JSON array with original\\ntranslation" }
        ]
        for (var i = 0; i < mockLines.length; i++)
            lyricsModel.append(mockLines[i])
        lyricsList.currentIndex = 0
    }

    Process {
        id: lyricsProc
        running: false
        command: ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/lyrics_fetcher.py", title, artist]
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                if (data.trim() === "") return
                try {
                    let parsed = JSON.parse(data)
                    if (Array.isArray(parsed) && parsed.length) {
                        lyricsModel.clear()
                        for(let i = 0; i < parsed.length; i++)
                            lyricsModel.append({"time": parsed[i].time, "text": parsed[i].text})
                        lyricsList.currentIndex = 0
                    } else generateMockLyrics()
                } catch(e) { generateMockLyrics() }
            }
        }
        onExited: { if (lyricsModel.count === 0) generateMockLyrics() }
    }

    function triggerLyricsFetch() {
        if (!title || title === "未播放") return
        lyricsModel.clear()
        lyricsModel.append({"time": 0, "text": "🎵 正在搜寻歌词..."})
        lyricsProc.running = false
        lyricsProc.running = true
    }

    onTitleChanged: triggerLyricsFetch()
    onArtistChanged: triggerLyricsFetch()

    // ======== 歌词高亮更新 ========
    function updateCurrentLyric(posMs) {
        if (!lyricsModel.count) return
        let newIdx = 0
        for (let i = 0; i < lyricsModel.count; i++) {
            if (lyricsModel.get(i).time <= posMs)
                newIdx = i
            else
                break
        }
        if (lyricsList.currentIndex !== newIdx)
            lyricsList.currentIndex = newIdx
    }

    // ======== 封面主色调提取 ========
    Canvas {
        id: colorExtractor
        width: 1; height: 1; visible: false
        property color extractedColor: _primary

        onImageLoaded: {
            var ctx = getContext("2d")
            ctx.drawImage(artUrl, 0, 0, 1, 1)
            var imgData = ctx.getImageData(0, 0, 1, 1).data
            var r = imgData[0] / 255.0, g = imgData[1] / 255.0, b = imgData[2] / 255.0
            var baseColor = Qt.rgba(r, g, b, 1.0)
            var h = baseColor.hslHue, s = baseColor.hslSaturation, l = baseColor.hslLightness
            s = Math.min(1.0, s * 1.5)
            if (s < 0.1) extractedColor = _primary
            else {
                l = Math.max(0.65, Math.min(0.85, l))
                extractedColor = Qt.hsla(h, s, l, 1.0)
            }
        }
    }

    onArtUrlChanged: {
        if (artUrl !== "")
            colorExtractor.loadImage(artUrl)
        else
            colorExtractor.extractedColor = _primary
    }

    property color dynamicThemeColor: colorExtractor.extractedColor
    Behavior on dynamicThemeColor { ColorAnimation { duration: 800; easing.type: Easing.OutQuint } }

    // ======== 进度同步 ========
    Timer {
        interval: 100
        running: playerValid && root.visible
        repeat: true
        onTriggered: {
            if (!currentPlayer || seekMa.pressed) return
            currentPos = (currentPlayer.position || 0)   // 微秒转毫秒
            if (showLyrics && lyricsModel.count > 0)
                updateCurrentLyric(currentPos)
        }
    }

    function formatTime(ms) {
        if (isNaN(ms) || ms <= 0) return "0:00"
        let seconds = Math.floor(ms)
        let m = Math.floor(seconds / 60)
        let s = seconds % 60
        return m + ":" + (s < 10 ? "0" : "") + s
    }
    property bool landscape: root.width > root.height

    // ======== UI 界面 ========
    Rectangle {
        id: mainBg
        anchors.fill: parent
        anchors.margins: 0
        radius: 0
        color: _surface_container_low
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: mainBg.width; height: mainBg.height; radius: mainBg.radius
            }
        }

        Image { id: bgSource; source: artUrl; anchors.fill: parent; fillMode: Image.PreserveAspectCrop; visible: false }
        FastBlur { anchors.fill: parent; source: bgSource; radius: 32; visible: artUrl !== "" }
        Rectangle { anchors.fill: parent; color: Qt.rgba(0, 0, 0, 0.6) }

        // 歌词切换按钮
        Rectangle {
            id: lyricsToggleBtn
            anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 16
            width: 38; height: 38; radius: 19
            color: "transparent"
            border.color: "#66ffffff"
            z: 10
            Text {
                anchors.centerIn: parent
                font.family: "Material Symbols Outlined";
                text: showLyrics ? "lyrics" : "album"
                font.pixelSize: 20
                color: "white"
            }
            MouseArea {
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                onClicked: showLyrics = !showLyrics
            }
        }

        // 中央内容区域
        Item {
            id: stage
            anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
            anchors.bottom: bottomControlPanel.top; anchors.margins: 20

            state: showLyrics ? "LYRICS_OPEN" : "LYRICS_CLOSED"
            states: [
                State {
                    name: "LYRICS_CLOSED"
                    PropertyChanges { target: coverContainer; x: (stage.width - coverContainer.width) / 2; scale: 1.0; visible: true }
                    PropertyChanges { target: infoContainer; opacity: 1; visible: true }
                    PropertyChanges { target: lyricsContainer; opacity: 0; visible: false }
                },
                State {
                    name: "LYRICS_OPEN"
                    PropertyChanges { target: coverContainer; visible: landscape; width: landscape ? stage.width / 4: 0; x: 30; height: stage.height * 0.9; }
                    PropertyChanges { target: infoContainer; opacity: 0; visible: false }
                    PropertyChanges { target: lyricsContainer; opacity: 1; visible: true }
                }
            ]
            transitions: Transition {
                ParallelAnimation {
                    NumberAnimation { targets: [coverContainer, lyricsContainer]; properties: "x,height,width"; duration: 500; easing.type: Easing.OutExpo }
                    NumberAnimation { properties: "opacity"; duration: 350 }
                }
            }

            // 封面
            Item {
                id: coverContainer
                width: landscape ? stage.width / 4: stage.width / 2; 
                height: stage.height * 0.8; 
                y: ( stage.height * 0.8 ) / 2 - ( landscape ? stage.width / 4: stage.width / 2 );
                visible: landscape
                Rectangle {
                    width: parent.width; height: parent.width; radius: 8; anchors.centerIn: parent
                    Image {
                        id: artImg; anchors.fill: parent; source: artUrl !== "" ? artUrl : ""
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle { width: artImg.width; height: artImg.height; radius: 8 }
                        }
                    }
                    Text {
                        anchors.centerIn: parent; text: "🎵"; font.pixelSize: 48
                        visible: artUrl === ""; color: "#ffffffcc"
                    }
                }
            }

            // 歌曲信息
            ColumnLayout {
                id: infoContainer
                width: parent.width
                y: coverContainer.y + coverContainer.height / 2 + coverContainer.width / 2 + 20
                spacing: 4
                Text {
                    text: title; color: "white"; font.pixelSize: 22; font.bold: true
                    Layout.alignment: Qt.AlignHCenter; elide: Text.ElideRight
                    font.family: root.fontfamily
                    Layout.maximumWidth: root.width - 100
                }
                Text {
                    text: artist; color: "#ddd"; font.pixelSize: 15
                    font.family: root.fontfamily
                    Layout.alignment: Qt.AlignHCenter; elide: Text.ElideRight
                }
                Text {
                    text: album; color: "#aaa"; font.pixelSize: 13
                    font.family: root.fontfamily

                    Layout.alignment: Qt.AlignHCenter; elide: Text.ElideRight
                    visible: album !== ""
                }
            }

            // 歌词视图
            Item {
                id: lyricsContainer
                width: stage.width * 0.8 - coverContainer.width; 
                height: stage.height; 
                x: coverContainer.width + stage.width * 0.1; 
                y: 0
                opacity: 0; 
                visible: false
                ListView {
                    id: lyricsList
                    anchors.fill: parent
                    model: lyricsModel
                    clip: true
                    spacing: 24
                    width: parent.width
                    preferredHighlightBegin: height / 2 - 40
                    preferredHighlightEnd: height / 2 + 40
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    interactive: true
                    highlightMoveDuration: 400
                    delegate: Text {
                        text: model.text
                        font.family: root.fontfamily
                        color: ListView.isCurrentItem ? dynamicThemeColor : "#ccffffff"
                        font.pixelSize: ListView.isCurrentItem ? 19 : 16
                        font.weight: ListView.isCurrentItem ? Font.DemiBold : Font.Normal
                        opacity: ListView.isCurrentItem ? 1.0 : 0.7
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WordWrap
                        Behavior on font.pixelSize { NumberAnimation { duration: 250 } }
                        Behavior on opacity { NumberAnimation { duration: 250 } }
                    }
                }
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: LinearGradient {
                        width: lyricsContainer.width; height: lyricsContainer.height
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "transparent" }
                            GradientStop { position: 0.2; color: "black" }
                            GradientStop { position: 0.8; color: "black" }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }
                }
            }
        }

        // 底部控制栏
        ColumnLayout {
            id: bottomControlPanel
            anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
            anchors.margins: 20; spacing: 8

            // 进度条
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: 32
                Rectangle {
                    height: 5; radius: 2; color: "#55ffffff"; anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                }
                Rectangle {
                    height: 5; radius: 2; color: dynamicThemeColor
                    width: parent.width * progress; anchors.verticalCenter: parent.verticalCenter
                    Behavior on width { SmoothedAnimation { velocity: 200; duration: 300 } }
                }
                Rectangle {
                    width: 12; height: 12; radius: 4; color: dynamicThemeColor
                    x: parent.width * progress - 6; anchors.verticalCenter: parent.verticalCenter
                    visible: seekMa.containsMouse || seekMa.pressed
                    Behavior on x { SmoothedAnimation { velocity: 300; duration: 200 } }
                }
                MouseArea {
                    id: seekMa
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    function seek(x) {
                        if (!currentPlayer || totalLength <= 0) return
                        let ratio = Math.max(0, Math.min(x, width)) / width
                        let newPosMs = ratio * totalLength          // 毫秒
                        currentPlayer.position = Math.round(newPosMs)  // 转微秒
                        currentPos = newPosMs
                    }
                    onPressed: (mouse) => seek(mouse.x)
                    onPositionChanged: (mouse) => {
                        if (pressed) seek(mouse.x)
                    }
                }
                RowLayout {
                    anchors.top: parent.bottom; anchors.topMargin: 2; width: parent.width
                    Text { text: playerValid ? formatTime(currentPos) : "0:00"; color: "#ccc"; font.pixelSize: 11; font.family: root.fontfamily }
                    Item { Layout.fillWidth: true }
                    Text { text: playerValid ? formatTime(totalLength) : "0:00"; color: "#ccc"; font.pixelSize: 11; font.family: root.fontfamily }
                }
            }

            // 控制按钮组
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 28
                component CtrlBtn : Text {
                    property bool active: false
                    font.family: "Material Symbols Outlined"; font.pixelSize: 24
                    color: active ? root.dynamicThemeColor : "white"; opacity: active ? 1.0 : 0.7
                    scale: ma.pressed ? 0.8 : (ma.containsMouse ? 1.1 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 150 } }
                    MouseArea { id: ma; anchors.fill: parent; anchors.margins: -10; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: parent.triggered() }
                    signal triggered() 
                }

                CtrlBtn { text: "shuffle"; active: currentPlayer ? currentPlayer.shuffle : false; onTriggered: if(currentPlayer && currentPlayer.shuffleSupported) currentPlayer.shuffle = !currentPlayer.shuffle  } 
                CtrlBtn { text: "skip_previous"; onTriggered: if (currentPlayer) currentPlayer.previous() } 
                
                Rectangle {
                    width: 60; height: 60; radius: 30; color: dynamicThemeColor 
                    scale: playMa.pressed ? 0.9 : (playMa.containsMouse ? 1.05 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 150 } }
                    Text { anchors.centerIn: parent; text: isPlaying ? "pause" : "play_arrow"; color: "white"; font.family: "Material Symbols Outlined"; font.pixelSize: 28 }
                    MouseArea { id: playMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: if (currentPlayer) currentPlayer.togglePlaying() }
                }

                CtrlBtn { text: "skip_next"; onTriggered: if (currentPlayer) currentPlayer.next() } 
                CtrlBtn { 
                    active: currentPlayer && currentPlayer.loopState !== MprisLoopState.None
                    text: (!currentPlayer) ? "repeat" : (currentPlayer.loopState === MprisLoopState.Track ? "repeat_one" : "repeat")
                    onTriggered: {
                        if(!currentPlayer || !currentPlayer.loopSupported) return;
                        if (currentPlayer.loopState === MprisLoopState.None) currentPlayer.loopState = MprisLoopState.Playlist; 
                        else if (currentPlayer.loopState === MprisLoopState.Playlist) currentPlayer.loopState = MprisLoopState.Track; 
                        else currentPlayer.loopState = MprisLoopState.None;
                    }
                } 
            }
        }
    }

    // 无播放器提示
    // Rectangle {
    //     anchors.centerIn: parent; width: 260; height: 80; radius: 20
    //     color: "#cc1e1e2e"; visible: !playerValid; z: 20
    //     Text {
    //         anchors.centerIn: parent; text: "🎧 没有检测到播放器"
    //         color: "white"; horizontalAlignment: Text.AlignHCenter; font.pixelSize: 14
    //     }
    // }
}
