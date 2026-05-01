import QtQuick 
import Quickshell 
import qs.Player

FloatingWindow {
    id: musicPlayer
    implicitHeight: 540
    implicitWidth: 720
    color: "transparent"
    Player {
        anchors.fill: parent
    }
}
