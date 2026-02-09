import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import Quickshell.Io

ShellRoot {
    // Finestra popup per il menu
    FloatingWindow {
        id: menuWindow
        visible: false
        width: 200
        height: menuColumn.height + 20
        color: "transparent"
        
        // Aggiorna posizione quando diventa visibile
        onVisibleChanged: {
            if (visible) {
                updatePosition()
            }
        }
        
        function updatePosition() {
            // Leggi la posizione del cursore da Hyprland
            var process = Process.exec("hyprctl", ["cursorpos"])
            process.finished.connect(() => {
                var output = process.stdout.trim()
                var coords = output.split(", ")
                if (coords.length === 2) {
                    menuWindow.x = parseInt(coords[0])
                    menuWindow.y = parseInt(coords[1])
                }
            })
        }
        
        Rectangle {
            anchors.fill: parent
            color: "#2e3440"
            border.color: "#4c566a"
            border.width: 1
            radius: 8
            
            Column {
                id: menuColumn
                anchors.fill: parent
                anchors.margins: 10
                spacing: 2
                
                MenuButton {
                    text: "Apri Terminale"
                    onClicked: {
                        Process.exec("kitty")
                        menuWindow.visible = false
                    }
                }
                
                MenuButton {
                    text: "File Manager"
                    onClicked: {
                        Process.exec("thunar")
                        menuWindow.visible = false
                    }
                }
                
                MenuSeparatorLine {}
                
                MenuButton {
                    text: "Screenshot"
                    onClicked: {
                        Process.exec("grim")
                        menuWindow.visible = false
                    }
                }
                
                MenuSeparatorLine {}
                
                MenuButton {
                    text: "Ricarica Hyprland"
                    onClicked: {
                        Process.exec("hyprctl", ["reload"])
                        menuWindow.visible = false
                    }
                }
                
                MenuButton {
                    text: "Esci"
                    onClicked: {
                        Process.exec("hyprctl", ["dispatch", "exit"])
                        menuWindow.visible = false
                    }
                }
            }
        }
        
        // MouseArea per chiudere quando clicchi fuori
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onExited: {
                closeTimer.start()
            }
        }
        
        Timer {
            id: closeTimer
            interval: 500
            onTriggered: {
                if (!menuWindow.activeFocus) {
                    menuWindow.visible = false
                }
            }
        }
    }
    
    // File watcher per monitorare il segnale di apertura menu
    FileDataSource {
        id: triggerFile
        path: "/tmp/quickshell-menu-trigger"
        
        onContentChanged: {
            console.log("Richiesta apertura menu")
            menuWindow.visible = !menuWindow.visible
        }
    }
    
    // Componente per i pulsanti del menu
    component MenuButton: Rectangle {
        property string text: ""
        signal clicked()
        
        width: parent.width
        height: 35
        color: mouseArea.containsMouse ? "#3b4252" : "transparent"
        radius: 4
        
        Text {
            text: parent.text
            color: "#eceff4"
            font.pixelSize: 13
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }
        
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: parent.clicked()
        }
    }
    
    // Componente per il separatore
    component MenuSeparatorLine: Rectangle {
        width: parent.width
        height: 1
        color: "#4c566a"
    }
}
