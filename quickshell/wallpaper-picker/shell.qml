import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ShellRoot {
    PanelWindow {
        id: window
        
        implicitWidth: 1200
        implicitHeight: 800
        visible: true
        
        property var hyprland: HyprlandFocusGrab {
            windows: [window]
            onActiveChanged: {
                if (!active) {
                    Qt.quit()
                }
            }
        }
        
        property string imgDir: Quickshell.env("HOME") + "/Pictures/Wallpapers"
        property var imageList: []
        property bool imagesLoaded: false
        
        // Colori pywal
        property var pywalColors: []
        property string background: "#1e1e2e"
        property string foreground: "#cdd6f4"
        property string color0: "#313244"
        property string color4: "#89b4fa"
        property string color8: "#45475a"
        
        Process {
            id: findProcess
            running: false
            
            stdout: SplitParser {
                onRead: data => {
                    var line = data.trim()
                    if (line !== "") {
                        console.log("Aggiunta immagine:", line)
                        window.imageList.push(line)
                        imageListModel.append({"path": line})
                    }
                }
            }
            
            onExited: {
                window.imagesLoaded = true
                statusText.text = "Trovate: " + window.imageList.length
                console.log("Caricamento completato, totale:", window.imageList.length)
            }
        }
        
        // Process per leggere i colori pywal
        Process {
            id: pywalProcess
            command: ["sh", "-c", "cat ~/.cache/wal/colors 2>/dev/null || echo ''"]
            running: true
            
            stdout: SplitParser {
                onRead: data => {
                    var colors = data.trim().split('\n').filter(function(c) { return c.length > 0 })
                    if (colors.length >= 8) {
                        console.log("Colori pywal caricati:", colors.length)
                        window.pywalColors = colors
                        window.background = colors[0]
                        window.foreground = colors[7]
                        window.color0 = colors[0]
                        window.color4 = colors[4]
                        window.color8 = colors.length > 8 ? colors[8] : colors[7]
                        console.log("Background:", window.background)
                        console.log("Foreground:", window.foreground)
                    } else {
                        console.log("Usando colori di default (pywal non trovato)")
                    }
                }
            }
            
            onExited: {
                console.log("pywalProcess completato, exit code:", exitCode)
            }
        }
        
        Component.onCompleted: {
            console.log("Cercando immagini in:", imgDir)
            hyprland.active = true
            loadImages()
        }
        
        function loadImages() {
            window.imageList = []
            imageListModel.clear()
            
            findProcess.command = [
                "find", imgDir, "-maxdepth", "3", "-type", "f",
                "(", "-iname", "*.jpg", "-o", 
                     "-iname", "*.jpeg", "-o",
                     "-iname", "*.png", "-o",
                     "-iname", "*.gif", "-o",
                     "-iname", "*.webp", ")"
            ]
            
            findProcess.running = true
        }
        
        Rectangle {
            id: bg
            anchors.fill: parent
            color: window.background
            radius: 10
            border.color: window.color8
            border.width: 2
            
            focus: true
            Keys.onEscapePressed: Qt.quit()
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                
                // Header
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    
                    Text {
                        text: "🖼️ Seleziona Wallpaper"
                        color: window.foreground
                        font.pixelSize: 18
                        font.bold: true
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Text {
                        id: statusText
                        text: "Caricamento..."
                        color: window.color8
                        font.pixelSize: 12
                    }
                }
                
                // Barra di ricerca
                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    placeholderText: "🔍 Cerca wallpaper..."
                    
                    background: Rectangle {
                        color: window.color0
                        radius: 5
                        border.color: searchField.activeFocus ? window.color4 : window.color8
                        border.width: 2
                    }
                    
                    color: window.foreground
                    font.pixelSize: 16
                    leftPadding: 15
                    rightPadding: 15
                    
                    Keys.onEscapePressed: Qt.quit()
                    
                    onTextChanged: {
                        imageListModel.clear()
                        for (var i = 0; i < window.imageList.length; i++) {
                            var basename = window.imageList[i].split('/').pop().toLowerCase()
                            if (searchField.text === "" || basename.includes(searchField.text.toLowerCase())) {
                                imageListModel.append({"path": window.imageList[i]})
                            }
                        }
                    }
                }
                
                // Griglia di immagini
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    
                    GridView {
                        id: gridView
                        cellWidth: 290
                        cellHeight: 290
                        
                        model: ListModel {
                            id: imageListModel
                        }
                        
                        delegate: Item {
                            width: 280
                            height: 280
                            
                            Rectangle {
                                id: card
                                anchors.fill: parent
                                anchors.margins: 5
                                color: mouseArea.containsMouse ? window.color8 : window.color0
                                radius: 10
                                
                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                                
                                // Scala quando hover
                                scale: mouseArea.containsMouse ? 1.05 : 1.0
                                Behavior on scale {
                                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                                }
                                
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 3
                                    
                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: window.background
                                        radius: 5
                                        clip: true
                                        
                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 2
                                            source: "file://" + model.path
                                            fillMode: Image.PreserveAspectFit
                                            asynchronous: true
                                            smooth: true
                                            
                                            onStatusChanged: {
                                                if (status === Image.Error) {
                                                    console.error("Errore caricamento:", model.path)
                                                } else if (status === Image.Ready) {
                                                    console.log("Caricata:", model.path)
                                                }
                                            }
                                        }
                                        
                                        Rectangle {
                                            anchors.fill: parent
                                            color: "transparent"
                                            border.color: window.color4
                                            border.width: mouseArea.containsMouse ? 3 : 0
                                            radius: 5
                                            
                                            Behavior on border.width {
                                                NumberAnimation { duration: 150 }
                                            }
                                        }
                                    }
                                    
                                    Text {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 20
                                        text: model.path ? model.path.split('/').pop() : ""
                                        color: window.foreground
                                        elide: Text.ElideMiddle
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: 9
                                        wrapMode: Text.NoWrap
                                    }
                                }
                                
                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    
                                    onClicked: {
                                        var basename = model.path.split('/').pop()
                                        var fullpath = model.path
                                        
                                        console.log("=== SELEZIONE ===")
                                        console.log("Nome file:", basename)
                                        console.log("Percorso completo:", fullpath)
                                        
                                        // Esegui setbg con il nome del file
                                        var cmd = "setbg " + basename
                                        console.log("Comando da eseguire:", cmd)
                                        
                                        setbgProcess.command = ["fish", "-c", cmd]
                                        setbgProcess.running = true
                                        
                                        // Non chiudere subito per vedere l'output
                                        // Qt.quit()
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Footer con bottoni
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    
                    Button {
                        text: "↻ Ricarica"
                        implicitWidth: 100
                        implicitHeight: 35
                        
                        contentItem: Text {
                            text: parent.text
                            color: window.background
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 13
                            font.bold: true
                        }
                        
                        background: Rectangle {
                            color: {
                                if (window.pywalColors.length > 6) {
                                    return parent.pressed ? window.pywalColors[5] : (parent.hovered ? window.pywalColors[14] : window.pywalColors[6])
                                }
                                return parent.pressed ? "#74c7ec" : (parent.hovered ? "#89dceb" : "#94e2d5")
                            }
                            radius: 5
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        
                        onClicked: {
                            statusText.text = "Ricaricamento..."
                            window.loadImages()
                        }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Button {
                        text: "✕ Chiudi"
                        implicitWidth: 100
                        implicitHeight: 35
                        
                        contentItem: Text {
                            text: parent.text
                            color: window.background
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 13
                            font.bold: true
                        }
                        
                        background: Rectangle {
                            color: {
                                if (window.pywalColors.length > 5) {
                                    return parent.pressed ? window.pywalColors[1] : (parent.hovered ? window.pywalColors[9] : window.pywalColors[5])
                                }
                                return parent.pressed ? "#f38ba8" : (parent.hovered ? "#f2cdcd" : "#f5c2e7")
                            }
                            radius: 5
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        
                        onClicked: Qt.quit()
                    }
                }
            }
        }
        
        // Process per impostare il wallpaper
        Process {
            id: setbgProcess
            running: false
            
            onRunningChanged: {
                console.log(">>> setbgProcess running:", running)
            }
            
            onExited: {
                console.log(">>> setbgProcess exited with code:", exitCode)
                if (exitCode === 0) {
                    console.log("✓ Wallpaper impostato con successo")
                } else {
                    console.error("✗ Errore setbg, exit code:", exitCode)
                }
                
                // Chiudi dopo aver visto l'output
                Qt.quit()
            }
            
            stderr: SplitParser {
                onRead: data => {
                    console.error(">>> setbg stderr:", data)
                }
            }
            
            stdout: SplitParser {
                onRead: data => {
                    console.log(">>> setbg stdout:", data)
                }
            }
        }
    }
}
