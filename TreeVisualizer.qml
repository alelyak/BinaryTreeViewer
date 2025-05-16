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
        // Создаем компонент узла
        var nodeComponent = Qt.createComponent("TreeNode.qml")
        if (nodeComponent.status !== Component.Ready) {
            console.error("Failed to create node component:", nodeComponent.errorString())
            return null
        }

        // Рассчитываем размеры узла
        var nodeWidth = 100  // Базовая ширина узла
        var nodeHeight = 50   // Высота узла

        // Создаем визуальный узел
        var nodeObj = nodeComponent.createObject(parentItem, {
            "x": x - nodeWidth/2,  // Центрируем по x
            "y": y,
            "width": nodeWidth,
            "height": nodeHeight,
            "nodeText": node.value
        })

        // Обработка левой ветви
        if (node.left && typeof node.left === "object") {
            var leftX = x - horizontalSpacing/2
            var leftY = y + 100

            // Рекурсивно создаем левый узел
            var leftNode = createNode(parentItem, node.left, leftX, leftY, horizontalSpacing/2)

            if (leftNode) {
                // Создаем линию от текущего узла к левому потомку
                createConnection(parentItem,
                               x, y + nodeHeight,          // Нижний центр текущего узла
                               leftX, leftY + nodeHeight/2) // Верхний центр левого узла
            }
        }

        // Обработка правой ветви
        if (node.right && typeof node.right === "object") {
            var rightX = x + horizontalSpacing/2
            var rightY = y + 100

            // Рекурсивно создаем правый узел
            var rightNode = createNode(parentItem, node.right, rightX, rightY, horizontalSpacing/2)

            if (rightNode) {
                // Создаем линию от текущего узла к правому потомку
                createConnection(parentItem,
                               x, y + nodeHeight,           // Нижний центр текущего узла
                               rightX, rightY + nodeHeight/2) // Верхний центр правого узла
            }
        }

        return nodeObj
    }

    // Создание соединительной линии (оптимизировано)
    function createConnection(parentItem, fromX, fromY, toX, toY) {
        var lineComponent = Qt.createComponent("TreeLine.qml")
        if (lineComponent.status === Component.Ready) {
            var lineObj = lineComponent.createObject(parentItem, {
                "x1": fromX,
                "y1": fromY,
                "x2": toX,
                "y2": toY,
                "z": -1 // Помещаем линии под узлы
            })
            return lineObj
        } else {
            console.error("Failed to create line:", lineComponent.errorString())
        }
        return null
    }

    // Фон
    Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"
    }
}
