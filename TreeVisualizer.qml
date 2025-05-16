import QtQuick 2.12
import QtQuick.Shapes 1.12

Item {
    id: root
    property var treeData

    // Автоматическое обновление при изменении данных
    onTreeDataChanged: {
        if (validateTreeData(treeData)) {
            drawTree()
        } else {
            console.error("Invalid tree data structure")
        }
    }

    // Валидация структуры дерева
    function validateTreeData(node) {
        if (!node || typeof node !== "object") return false
        if (!node.hasOwnProperty("value")) return false
        return true
    }

    // Функция отрисовки дерева с проверкой размера
    function drawTree() {
        // Очистка предыдущего дерева
        for (var i = children.length - 1; i >= 0; i--) {
            if (children[i] !== background) {
                children[i].destroy()
            }
        }

        // Проверка и расчет размера
        var treeSize = calculateTreeSize(treeData)
        if (treeSize <= 0) {
            console.error("Invalid tree size:", treeSize)
            return
        }

        // Построение дерева
        createNode(root, treeData, width/2, 50, width/3)
    }

    // Расчет размера дерева
    function calculateTreeSize(node) {
        if (!node || !node.value) return 0
        var size = 1 // Текущий узел
        if (node.left) size += calculateTreeSize(node.left)
        if (node.right) size += calculateTreeSize(node.right)
        return size
    }

    // Создание узла (оптимизированная версия)
    function createNode(parentItem, node, x, y, horizontalSpacing) {
        var nodeComponent = Qt.createComponent("TreeNode.qml")
        if (nodeComponent.status !== Component.Ready) {
            console.error("Component error:", nodeComponent.errorString())
            return null
        }

        var nodeObj = nodeComponent.createObject(parentItem, {
            "x": x - 25,
            "y": y,
            "nodeText": node.value
        })

        // Обработка левой ветви
        if (node.left && typeof node.left === "object") {
            var leftX = x - horizontalSpacing/2
            var leftY = y + 100
            createNode(parentItem, node.left, leftX, leftY, horizontalSpacing/2)
            createConnection(parentItem, x, y + 50, leftX + 25, leftY)
        }

        // Обработка правой ветви
        if (node.right && typeof node.right === "object") {
            var rightX = x + horizontalSpacing/2
            var rightY = y + 100
            createNode(parentItem, node.right, rightX, rightY, horizontalSpacing/2)
            createConnection(parentItem, x, y + 50, rightX + 25, rightY)
        }

        return nodeObj
    }

    // Создание соединительной линии (оптимизировано)
    function createConnection(parentItem, x1, y1, x2, y2) {
        var lineComponent = Qt.createComponent("TreeLine.qml")
        if (lineComponent.status === Component.Ready) {
            lineComponent.createObject(parentItem, {
                "x1": x1, "y1": y1,
                "x2": x2, "y2": y2
            })
        }
    }

    // Фон
    Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"
    }
}
