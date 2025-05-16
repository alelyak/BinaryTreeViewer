import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import TreeModel 1.0
import QtQuick.Dialogs 1.3

ApplicationWindow {
    id: root
    width: 800
    height: 600
    visible: true
    title: qsTr("Binary Tree Viewer")

    TreeModel {
        id: treeModel
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Button {
                text: "Open JSON File"
                onClicked: fileDialog.open()
            }
            Label {
                text: fileDialog.selectedFile
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            TreeVisualizer {
                treeData: treeModel.treeData
                anchors.fill: parent
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select JSON File"
        nameFilters: ["JSON files (*.json)"]
        property string selectedFile: ""

        onAccepted: {
            selectedFile = fileDialog.fileUrl.toString()
            treeModel.loadFromFile(selectedFile.replace("file://", ""))
        }
    }
}
