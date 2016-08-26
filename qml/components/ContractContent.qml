import QtQuick 2.0
import QtQuick.Controls 1.2

Item {
    anchors.fill: parent

    Column {
        anchors.fill: parent
        anchors.margins: 0.05 * dpi
        anchors.topMargin: 0.1 * dpi
        spacing: 0.1 * dpi

        ContractDetails {
            id: details
        }

        ContractCalls {
            id: calls
        }

        Button {
            id: addButton
            text: "Add Contract"
            width: parent.width
            height: 1 * dpi

            onClicked: details.open(-1)
        }

        TableView {
            id: contractView
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height - parent.spacing - addButton.height

            TableViewColumn {
                role: "name"
                title: qsTr("Name")
                width: 2.25 * dpi
            }
            TableViewColumn {
                role: "address"
                title: qsTr("Address")
                width: 5 * dpi
            }
            model: contractModel

            Menu {
                id: rowMenu

                MenuItem {
                    text: qsTr("Call")
                    onTriggered: {
                        calls.open(contractView.currentRow)
                    }
                }

                MenuItem {
                    text: qsTr("Edit")
                    onTriggered: {
                        details.open(transactionModel.getJson(contractView.currentRow, true))
                    }
                }

                MenuItem {
                    text: qsTr("Find on blockchain explorer")
                    onTriggered: {
                        var url = "http://" + (ipc.testnet ? "testnet." : "") + "etherscan.io/address/" + contractModel.getAddress(contractView.currentRow)
                        Qt.openUrlExternally(url)
                    }
                }

                MenuItem {
                    text: qsTr("Copy Address")
                    onTriggered: {
                        clipboard.setText(contractModel.getAddress(contractView.currentRow))
                    }
                }

                MenuItem {
                    text: qsTr("Delete")
                    onTriggered: {
                        contractModel.deleteContract(contractView.currentRow)
                    }
                }
            }

            rowDelegate: Item {
                SystemPalette {
                    id: osPalette
                    colorGroup: SystemPalette.Active
                }

                height: 0.2 * dpi

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    height: parent.height
                    color: styleData.selected ? osPalette.highlight : (styleData.alternate ? osPalette.alternateBase : osPalette.base)
                    MouseArea {
                        anchors.fill: parent
                        propagateComposedEvents: true
                        acceptedButtons: Qt.RightButton

                        onReleased: {
                            if ( contractView.currentRow >= 0 ) {
                                rowMenu.popup()
                            }
                        }
                    }
                }
            }
        }
    }
}