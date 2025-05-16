import QtQuick 2.12
import QtQuick.Shapes 1.12

Shape {
    id: root
    property real x1: 0
    property real y1: 0
    property real x2: 0
    property real y2: 0

    ShapePath {
        strokeWidth: 2
        strokeColor: "#555"
        startX: root.x1
        startY: root.y1
        PathLine { x: root.x2; y: root.y2 }
    }
}
