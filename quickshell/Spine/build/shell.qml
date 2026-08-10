import QtQuick
import Quickshell
import SpineQml 1.0

Rectangle {
    width: 4000
    height: 2000
    color: "#000000"
    x: -1000
    y: -500
    Item {
        id: dragContainer
        width: spineAnim.width
        height: spineAnim.height
        x: 1000
        y: 500

        // 旋转应用到 SpineItem 上
        SpineItem {
            id: spineAnim
            width: 800
            height: 800
            anchors.centerIn: parent
            rotation: 180

            // 使用 character + dataRoot 自动拼路径，支持 IPC 切换
            dataRoot: "/home/kina/temp/code/rust/spine/data"
            character: "yuzu"
            scale: 0.35
            timeScale: 1.0
            autoPlay: true
            animationName: "Idle_01"

            onLoadedChanged: {
                if (loaded) {
                    console.log("Spine animation loaded successfully");
                }
            }

            onLoadError: function (message) {
                console.error("Spine load error:", message);
            }
        }

        // 拖动 + 滚轮旋转
        MouseArea {
            anchors.fill: parent
            drag.target: dragContainer
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumX: parent.parent ? parent.parent.width - dragContainer.width : 800
            drag.maximumY: parent.parent ? parent.parent.height - dragContainer.height : 800

            acceptedButtons: Qt.LeftButton | Qt.RightButton

            // 滚轮旋转（每次 15°）
            // onWheel: function (wheel) {
            //     dragContainer.rotation += wheel.angleDelta.y > 0 ? 15 : -15;
            //     console.log("Spine: rotation =", dragContainer.rotation);
            // }

            onClicked: function (mouse) {
                if (mouse.button === Qt.RightButton) {
                    // 轨道 1 叠加表情（不循环，播完自动回到 Idle_01）
                    var anims = ["00", "01", "02", "03", "04", "05", "06", "07", "Eye_Close_01"];
                    var idx = anims.indexOf(spineAnim.queuedAnimation);
                    var next = anims[(idx + 1) % anims.length];
                    spineAnim.queueAnimation(next, false, 0);
                    console.log("Spine: expression on track 1 =", next);
                }
            }
        }
    }

    // IPC: 监听 /tmp/spine_char 文件来切换角色
    // 用法: echo "aris" > /tmp/spine_char
    FileWatcher {
        id: charWatcher
        filePath: "/tmp/spine_char"
        onTextChanged: {
            console.log("IPC: switching to character:", text);
            spineAnim.character = text;
        }
    }
}
