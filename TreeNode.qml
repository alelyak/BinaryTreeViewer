import QtQuick 2.12

Rectangle {
    id: root
    property string nodeText: ""

    width: Math.max(80, content.width + 20) // Автоподстройка под текст
    height: 50
    radius: 5
    color: "#4CAF50"
    border.color: "#2E7D32"
    border.width: 2

    Text {
        id: content
        text: root.nodeText
        anchors.centerIn: parent
        color: "white"
        font.bold: true
        font.pixelSize: 14
        padding: 5
    }
}
