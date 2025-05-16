import QtQuick 2.12
import QtQuick.Shapes 1.12

Item {
    id: root
    property var treeData

    onTreeDataChanged: {
        // Очищаем предыдущее дерево
        for (var i = children.length - 1; i >= 0; i--) {
            if (children[i] !== background) {
                children[i].destroy()
            }
        }

        // Строим новое дерево
        if (treeData && typeof treeData === "object") {
            createNode(root, treeData, width/2, 50, 300)
        }
    }

    function createNode(parentItem, node, x, y, horizontalSpacing) {
        if (!node) return null

        var component = Qt.createComponent("TreeNode.qml")
        if (component.status !== Component.Ready) {
            console.error("Error creating component:", component.errorString())
            return null
        }

        var nodeObj = component.createObject(parentItem, {
            "x": x - 25, // Центрируем узел
            "y": y,
            "nodeText": node.value || "Node"
        })

        if (node.left) {
            var leftX = x - horizontalSpacing/2
            var leftY = y + 100
            createNode(parentItem, node.left, leftX, leftY, horizontalSpacing/2)

            // Создаем соединительную линию
            var line = Qt.createQmlObject('
                import QtQuick.Shapes 1.15
                Shape {
                    ShapePath {
                        strokeWidth: 2
                        strokeColor: "black"
                        startX: ' + (x) + '; startY: ' + (y + 50) + '
                        PathLine { x: ' + (leftX + 25) + '; y: ' + (leftY) + ' }
                    }
                }', parentItem)
        }

        if (node.right) {
            var rightX = x + horizontalSpacing/2
            var rightY = y + 100
            createNode(parentItem, node.right, rightX, rightY, horizontalSpacing/2)

            // Создаем соединительную линию
            var line = Qt.createQmlObject('
                import QtQuick.Shapes 1.15
                Shape {
                    ShapePath {
                        strokeWidth: 2
                        strokeColor: "black"
                        startX: ' + (x) + '; startY: ' + (y + 50) + '
                        PathLine { x: ' + (rightX + 25) + '; y: ' + (rightY) + ' }
                    }
                }', parentItem)
        }

        return nodeObj
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"
    }
}
