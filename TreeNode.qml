import QtQuick 2.12

Rectangle {
    id: root
    property string nodeText: ""

    width: 50
    height: 50
    radius: 25
    color: "#4CAF50"
    border.color: "#2E7D32"
    border.width: 2

    Text {
        text: root.nodeText
        anchors.centerIn: parent
        color: "white"
        font.bold: true
    }
}
