import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

ColumnLayout {
    id: layoutServer
    anchors.fill: parent
    anchors.margins: 10
    spacing: 20

    RowLayout {
        Image {
            source: "qrc:///images/icon-servers.svg"
            sourceSize.width: 40
            sourceSize.height: 40
        }

        Text {
            text: qsTr("Servers")
            color: "white"
            font.pointSize: 24
        }

        Item {      // spacer item
            Layout.fillWidth: true
            Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
        }

        Button {
            text: qsTr("Add New Servers")
            contentItem: Text {
                text: parent.text
                color: "white"
            }
            background: Rectangle {
                color: parent.enabled ? (parent.down ? "#2980b9" : "#3498db") : "#bdc3c7"
                radius: 4
            }
            onClicked: function() {
                popUpServer.height = layoutServer.height
                popUpServer.width = layoutServer.width
                popUpServer.open()
            }
        }
    }

    Item {
         Layout.fillWidth: true
         Layout.fillHeight: true

         ListView {
             id: listViewServers
             anchors.fill: parent
             anchors.rightMargin: 5
             flickableDirection: Flickable.HorizontalAndVerticalFlick
             headerPositioning: ListView.OverlayHeader
             clip: true

             function getColumnWidth(index) {
                 // TODO
                 return listViewServers.width / 6
             }

             header: Row {
                 spacing: 1
                 z: 4

                 function itemAt(index) {
                     return listViewServersRepeater.itemAt(index)
                 }
                 Repeater {
                     id: listViewServersRepeater
                     model: [
                         qsTr("Name"), qsTr("Server"), qsTr("Protocol"), qsTr("Status"),
                         qsTr("Latency"), qsTr("Last Used")
                     ]
                     Label {
                         text: modelData
                         color: "white"
                         font.bold: true
                         padding: 10
                         width: listViewServers.getColumnWidth(index)
                         background: Rectangle {
                             color: "#354759"
                         }
                     }
                 }
             }

             model: listViewServersModel
             delegate: Column {
                 Row {
                     spacing: 1
                     Repeater {
                         model: dataValues
                         ItemDelegate {
                             text: dataValue
                             width: listViewServers.getColumnWidth(index)

                             contentItem: Text {
                                 clip: true
                                 color: "white"
                                 text: parent.text
                             }
                             background: Rectangle {
                                 color: "transparent"
                             }
                         }
                     }
                 }
                 Rectangle {
                     color: "#3b4d5d"
                     width: parent.width
                     height: 1
                 }
             }

             ListModel {
                 id: listViewServersModel
             }

             ScrollIndicator.horizontal: ScrollIndicator { }
             ScrollIndicator.vertical: ScrollIndicator { }
         }
    }

    Popup {
        id: popUpServer
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
            color: "#2e3e4e"
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 20

            RowLayout {
                Label {
                    text: qsTr("Add new servers by ")
                    color: "white"
                }

                ComboBox {
                    id: comboAddServerMethod
                    Layout.fillWidth: true
                    model: ListModel{
                        ListElement { text: qsTr("Manually setting up a V2Ray server") }
                        ListElement { text: qsTr("Manually setting up a Shadowsocks server") }
                        ListElement { text: qsTr("Subscription URL") }
                        ListElement { text: qsTr("V2Ray config files") }
                        ListElement { text: qsTr("V2Ray Desktop config files") }
                        ListElement { text: qsTr("Shadowsocks config files (gui-config.json)") }
                    }
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                    contentItem: Text {
                        text: comboAddServerMethod.displayText
                        color: "white"
                        leftPadding: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    onCurrentTextChanged: function() {
                        layoutServerV2rayManually.visible = false
                        layoutServerShadowsocksManually.visible = false
                        layoutServerSubscriptionUrl.visible = false
                        layoutServerJsonFiles.visible = false

                        if ( comboAddServerMethod.currentText === qsTr("Manually setting up a V2Ray server") ) {
                            layoutServerV2rayManually.visible = true
                        } else if ( comboAddServerMethod.currentText === qsTr("Manually setting up a Shadowsocks server") ) {
                            layoutServerShadowsocksManually.visible = true
                        } else if ( comboAddServerMethod.currentText === qsTr("Subscription URL") ) {
                            layoutServerSubscriptionUrl.visible = true
                        } else {
                            layoutServerJsonFiles.visible = true
                        }
                    }
                }
            }

            GridLayout {
                id: layoutServerV2rayManually
                columns: 4
                flow: GridLayout.LeftToRight
                rowSpacing: 20
                columnSpacing: 20

                Label {
                    text: qsTr("Server Name")
                    color: "white"
                    rightPadding: 28
                }

                TextField {
                    id: textV2RayServerName
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: HongKong-Server-1")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    text: qsTr("Auto Connect")
                    color: "white"
                }

                CheckBox {
                    id: checkboxV2RayAutoConnect
                    leftPadding: -2
                }

                Label {
                    text: qsTr("Server Address")
                    color: "white"
                }

                TextField {
                    id: textV2RayServerAddr
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: hk.example.com")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    text: qsTr("Server Port")
                    color: "white"
                }

                TextField {
                    id: textV2RayServerPort
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: 443")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    text: qsTr("ID")
                    color: "white"
                }

                TextField {
                    id: textV2RayId
                    color: "white"
                    Layout.minimumWidth: 200
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: 27848739-7e62-4138-9fd3-098a63964b6b")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    text: qsTr("Alter ID")
                    color: "white"
                }

                TextField {
                    id: textV2RayAlterId
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: 4")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    text: qsTr("Level")
                    color: "white"
                }

                TextField {
                    id: textV2RayLevel
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: 1")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    text: qsTr("Security")
                    color: "white"
                }

                ComboBox {
                    id: textV2RaySecurity
                    Layout.minimumWidth: 180
                    Layout.fillWidth: true
                    model: ListModel{
                        ListElement { text: "Auto" }
                        ListElement { text: "AES-128-GCM" }
                        ListElement { text: "AES-192-CFB" }
                        ListElement { text: "CHACHA20-PLOY1305" }
                    }
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                    contentItem: Text {
                        text: textV2RaySecurity.displayText
                        color: "white"
                        leftPadding: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Label {
                    text: qsTr("Network")
                    color: "white"
                }

                ComboBox {
                    id: textV2RayNetwork
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    model: ListModel{
                        ListElement { text: "TCP" }
                        ListElement { text: "KCP" }
                        ListElement { text: "Websocket" }
                        ListElement { text: "HTTP/2" }
                        ListElement { text: "Domain Socket" }
                        ListElement { text: "QUIC" }
                    }
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                    contentItem: Text {
                        text: textV2RayNetwork.displayText
                        color: "white"
                        leftPadding: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    onCurrentTextChanged: function() {
                        labelV2RayTcpHeaderType.visible = false
                        comboV2RayTcpHeaderType.visible = false
                        labelV2RayKcpMtu.visible = false
                        textV2RayKcpMtu.visible = false
                        labelV2RayKcpTti.visible = false
                        textV2RayKcpTti.visible = false
                        labelV2RayKcpUplinkCapcity.visible = false
                        textV2RayKcpUplinkCapcity.visible = false
                        labelV2RayKcpDownlinkCapcity.visible = false
                        textV2RayKcpDownlinkCapcity.visible = false
                        labelV2RayReadBufferSize.visible = false
                        textV2RayKcpReadBufferSize.visible = false
                        labelV2RayKcpWriteBufferSize.visible = false
                        textV2RayKcpWriteBufferSize.visible = false
                        labelV2RayKcpCongestion.visible = false
                        checkboxV2RayKcpCongestion.visible = false
                        labelV2RayNetworkHost.visible = false
                        textV2RayNetworktHost.visible = false
                        labelV2RayNetworkPath.visible = false
                        textV2RayNetworkPath.visible = false
                        labelV2RayDomainSocketFilePath.visible = false
                        textV2RayDomainSocketFilePath.visible = false
                        labelV2RayQuicSecurity.visible = false
                        textV2RayQuicSecurity.visible = false
                        labelV2RayPacketHeader.visible = false
                        textV2RayPacketHeader.visible = false
                        labelV2RayQuicKey.visible = false
                        textV2RayQuicKey.visible = false

                        if ( textV2RayNetwork.currentText === qsTr("TCP") ) {
                            labelV2RayTcpHeaderType.visible = true
                            comboV2RayTcpHeaderType.visible = true
                        } else if ( textV2RayNetwork.currentText === qsTr("KCP") ) {
                            labelV2RayKcpMtu.visible = true
                            textV2RayKcpMtu.visible = true
                            labelV2RayKcpTti.visible = true
                            textV2RayKcpTti.visible = true
                            labelV2RayKcpUplinkCapcity.visible = true
                            textV2RayKcpUplinkCapcity.visible = true
                            labelV2RayKcpDownlinkCapcity.visible = true
                            textV2RayKcpDownlinkCapcity.visible = true
                            labelV2RayReadBufferSize.visible = true
                            textV2RayKcpReadBufferSize.visible = true
                            labelV2RayKcpWriteBufferSize.visible = true
                            textV2RayKcpWriteBufferSize.visible = true
                            labelV2RayKcpCongestion.visible = true
                            checkboxV2RayKcpCongestion.visible = true
                            labelV2RayPacketHeader.visible = true
                            textV2RayPacketHeader.visible = true
                        } else if ( textV2RayNetwork.currentText === qsTr("Websocket") ||
                                    textV2RayNetwork.currentText === qsTr("HTTP/2") ) {
                            labelV2RayNetworkHost.visible = true
                            textV2RayNetworktHost.visible = true
                            labelV2RayNetworkPath.visible = true
                            textV2RayNetworkPath.visible = true
                        } else if ( textV2RayNetwork.currentText === qsTr("Domain Socket") ) {
                            labelV2RayDomainSocketFilePath.visible = true
                            textV2RayDomainSocketFilePath.visible = true
                        } else if ( textV2RayNetwork.currentText === qsTr("QUIC") ) {
                            labelV2RayQuicSecurity.visible = true
                            textV2RayQuicSecurity.visible = true
                            labelV2RayPacketHeader.visible = true
                            textV2RayPacketHeader.visible = true
                            labelV2RayQuicKey.visible = true
                            textV2RayQuicKey.visible = true
                        }
                    }
                }

                Label {
                    text: qsTr("Network Security")
                    color: "white"
                }

                ComboBox {
                    id: textV2RayNetworkSecurity
                    Layout.fillWidth: true
                    model: ListModel{
                        ListElement { text: "None" }
                        ListElement { text: "TLS" }
                    }
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                    contentItem: Text {
                        text: textV2RayNetworkSecurity.displayText
                        color: "white"
                        leftPadding: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Label {
                    text: qsTr("Allow Insecure")
                    color: "white"
                }

                CheckBox {
                    id: checkboxV2RayAllowInsecure
                    leftPadding: -2
                }

                Label {
                    id: labelV2RayTcpHeaderType
                    text: qsTr("TCP Header")
                    color: "white"
                }

                ComboBox {
                    id: comboV2RayTcpHeaderType
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    model: ListModel{
                        ListElement { text: qsTr("None") }
                        ListElement { text: qsTr("HTTP") }
                    }
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                    contentItem: Text {
                        text: comboV2RayTcpHeaderType.displayText
                        color: "white"
                        leftPadding: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Label {
                    id: labelV2RayKcpMtu
                    text: qsTr("MTU")
                    color: "white"
                }

                TextField {
                    id: textV2RayKcpMtu
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Maximum transmission unit. Default value: 1350.")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    id: labelV2RayKcpTti
                    text: qsTr("TTI")
                    color: "white"
                }

                TextField {
                    id: textV2RayKcpTti
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Transmission time interval. Default value: 50")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    id: labelV2RayKcpUplinkCapcity
                    text: qsTr("Uplink Capcity")
                    color: "white"
                }

                TextField {
                    id: textV2RayKcpUplinkCapcity
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Default value: 5.")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    id: labelV2RayKcpDownlinkCapcity
                    text: qsTr("Downlink Capcity")
                    color: "white"
                }

                TextField {
                    id: textV2RayKcpDownlinkCapcity
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Default value: 5.")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    id: labelV2RayReadBufferSize
                    text: qsTr("Read Buffer Size")
                    color: "white"
                }

                TextField {
                    id: textV2RayKcpReadBufferSize
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Default value: 2.")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    id: labelV2RayKcpWriteBufferSize
                    text: qsTr("Downlink Capcity")
                    color: "white"
                }

                TextField {
                    id: textV2RayKcpWriteBufferSize
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Default value: 2.")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    id: labelV2RayKcpCongestion
                    text: qsTr("Congestion")
                    color: "white"
                }

                CheckBox {
                    id: checkboxV2RayKcpCongestion
                    leftPadding: -2
                }

                Label {
                    id: labelV2RayNetworkHost
                    text: qsTr("Host")
                    color: "white"
                }

                TextField {
                    id: textV2RayNetworktHost
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: example.com")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    id: labelV2RayNetworkPath
                    text: qsTr("Path")
                    color: "white"
                }

                TextField {
                    id: textV2RayNetworkPath
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: /ray")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    id: labelV2RayDomainSocketFilePath
                    text: qsTr("Socket File Path")
                    color: "white"
                }

                TextField {
                    id: textV2RayDomainSocketFilePath
                    color: "white"
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: /path/to/domain/socket/file")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    id: labelV2RayQuicSecurity
                    text: qsTr("QUIC Security")
                    color: "white"
                }

                ComboBox {
                    id: textV2RayQuicSecurity
                    Layout.fillWidth: true
                    model: ListModel{
                        ListElement { text: "None" }
                        ListElement { text: "AES-128-GCM" }
                        ListElement { text: "CHACHA20-PLOY1305" }
                    }
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                    contentItem: Text {
                        text: textV2RayNetworkSecurity.displayText
                        color: "white"
                        leftPadding: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Label {
                    id: labelV2RayPacketHeader
                    text: qsTr("Packet Header")
                    color: "white"
                }

                ComboBox {
                    id: textV2RayPacketHeader
                    Layout.fillWidth: true
                    model: ListModel{
                        ListElement { text: "srtp" }
                        ListElement { text: "utp" }
                        ListElement { text: "wechat-video" }
                        ListElement { text: "dtls" }
                        ListElement { text: "wireguard" }
                    }
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                    contentItem: Text {
                        text: textV2RayNetworkSecurity.displayText
                        color: "white"
                        leftPadding: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Label {
                    id: labelV2RayQuicKey
                    text: qsTr("QUIC Key")
                    color: "white"
                }

                TextField {
                    id: textV2RayQuicKey
                    color: "white"
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: Any String")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Button {
                    id: buttonV2RayAddServer
                    text: qsTr("Add Server")
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                    }
                    background: Rectangle {
                        color: parent.enabled ? (parent.down ? "#2980b9" : "#3498db") : "#bdc3c7"
                        radius: 4
                    }
                    onClicked: function() {
                    }
                }
            }

            GridLayout {
                id: layoutServerShadowsocksManually
                columns: 4
                flow: GridLayout.LeftToRight
                rowSpacing: 20
                columnSpacing: 20
                visible: false

                Label {
                    text: qsTr("Server Name")
                    color: "white"
                    rightPadding: 28
                }

                TextField {
                    id: textShadowsocksServerName
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: HongKong-Server-1")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    text: qsTr("Auto Connect")
                    color: "white"
                }

                CheckBox {
                    id: checkboxShadowsocksAutoConnect
                    leftPadding: -2
                }

                Label {
                    text: qsTr("Server Address")
                    color: "white"
                }

                TextField {
                    id: textShadowsocksServerAddr
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: hk.example.com")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    text: qsTr("Server Port")
                    color: "white"
                }

                TextField {
                    id: textShadowsocksServerPort
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: 8388")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Label {
                    text: qsTr("Security")
                    color: "white"
                }

                ComboBox {
                    id: comboShadowsocksEncryptionMethod
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    model: ListModel{
                        ListElement { text: "AES-128-CFB" }
                        ListElement { text: "AES-128-CTR" }
                        ListElement { text: "AES-128-GCM" }
                        ListElement { text: "AES-192-CFB" }
                        ListElement { text: "AES-192-CTR" }
                        ListElement { text: "AES-192-GCM" }
                        ListElement { text: "AES-256-CFB" }
                        ListElement { text: "AES-256-CTR" }
                        ListElement { text: "AES-256-GCM" }
                        ListElement { text: "BF-CFB" }
                        ListElement { text: "CAMELLIA-128-CFB" }
                        ListElement { text: "CAMELLIA-192-CFB" }
                        ListElement { text: "CAMELLIA-256-CFB" }
                        ListElement { text: "CAST5-CFB" }
                        ListElement { text: "CHACHA20" }
                        ListElement { text: "CHACHA20-IETF" }
                        ListElement { text: "CHACHA20-IETF-PLOY1305" }
                        ListElement { text: "DES-CFB" }
                        ListElement { text: "IDEA-CFB" }
                        ListElement { text: "RC4-MD5" }
                        ListElement { text: "SALSA20" }
                        ListElement { text: "SEED-CFB" }
                        ListElement { text: "SERPENT-256-CFB" }
                    }
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                    contentItem: Text {
                        text: comboShadowsocksEncryptionMethod.displayText
                        color: "white"
                        leftPadding: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    id: buttonShadowsocksAddServer
                    text: qsTr("Add Server")
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                    }
                    background: Rectangle {
                        color: parent.enabled ? (parent.down ? "#2980b9" : "#3498db") : "#bdc3c7"
                        radius: 4
                    }
                    onClicked: function() {
                    }
                }
            }

            GridLayout {
                id: layoutServerSubscriptionUrl
                columns: 2
                flow: GridLayout.LeftToRight
                rowSpacing: 20
                columnSpacing: 20
                visible: false

                Label {
                    text: qsTr("Subscription URL")
                    color: "white"
                    rightPadding: 2
                }

                TextField {
                    id: textSubsriptionUrl
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: https://url/to/subscription")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Button {
                    id: buttonSubscriptionAddServer
                    text: qsTr("Add Servers")
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                    }
                    background: Rectangle {
                        color: parent.enabled ? (parent.down ? "#2980b9" : "#3498db") : "#bdc3c7"
                        radius: 4
                    }
                    onClicked: function() {
                    }
                }
            }

            GridLayout {
                id: layoutServerJsonFiles
                columns: 3
                flow: GridLayout.LeftToRight
                rowSpacing: 20
                columnSpacing: 20
                visible: false

                Label {
                    text: qsTr("Config File Path")
                    color: "white"
                    rightPadding: 12
                }

                TextField {
                    id: textConfigFilePath
                    color: "white"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Example: /path/to/config.json")
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, .1)
                        border.color: Qt.rgba(120, 130, 140, .2)
                    }
                }

                Button {
                    id: buttonSelectConfigFile
                    text: qsTr("Choose File")
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                    }
                    background: Rectangle {
                        color: parent.enabled ? (parent.down ? "#2980b9" : "#3498db") : "#bdc3c7"
                        radius: 4
                    }
                    onClicked: function() {
                    }
                }

                Button {
                    id: buttonConfigAddServer
                    text: qsTr("Add Servers")
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                    }
                    background: Rectangle {
                        color: parent.enabled ? (parent.down ? "#2980b9" : "#3498db") : "#bdc3c7"
                        radius: 4
                    }
                    onClicked: function() {
                    }
                }
            }

            Item {      // spacer item
                Layout.fillWidth: true
                Layout.fillHeight: true
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
            }
        }
    }
}
