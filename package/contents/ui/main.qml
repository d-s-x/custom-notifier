import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents


// TEST:
// plasmoidviewer  --applet .

Item {
    id: main
    
    anchors.fill: parent

    property int noUpdate:  0
    property int update:    1
    property int errUpdate: 2
    property int curType:   noUpdate
    property var mainIcon: plasmoid.configuration.iconNoUpdate

    Plasmoid.status: (curType == noUpdate) ? PlasmaCore.Types.PassiveStatus : PlasmaCore.Types.ActiveStatus

    
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: CompactRepresentation { }
    
    Component.onCompleted: {
        plasmoidStartTimer.start()
    }
    
    PlasmaCore.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: {
			var exitCode = data["exit code"]
			var stdout = data["stdout"]
			var stderr = data["stderr"]
			
			exited(exitCode, stdout, stderr)
			disconnectSource(sourceName)
		}
		function exec(cmd) {
			connectSource(cmd)
		}
		signal exited(int exitCode, string stdout, string stderr)
	}   
    
	Connections {
		target: executable
		onExited: {
            if (exitCode == 0) {
                if (stdout.length != 0) {
                    curType = update
                    updateTooltip(i18n(stdout.replace(/\n/g, '<br />')))
                }
                else {
                    curType = noUpdate
                    updateTooltip(i18n('System up to date'))
                }
            }
            else {
                if (stderr.length != 0) {
                    curType = errUpdate
                    updateTooltip(stderr.replace(/\n/g, '<br />'))
                }
                else {
                    curType = errUpdate
                    updateTooltip(i18n('Script in error'))
                }
            }
		}
    }
    
        
   	PlasmaCore.DataSource {
		id: theupdate
		engine: "executable"
		connectedSources: []
		onNewData: {
            exited()
            disconnectSource(sourceName)
        }
		function exec(cmd) {
			theupdate.connectSource(cmd)
		}
		signal exited()
    }
    
    Connections {
		target: theupdate
		onExited: {
            if (plasmoid.configuration.chkCommand.length > 0) {
                executable.exec(plasmoid.configuration.chkCommand)
            }
        }
	}
    
    function updateIcon() {
        if (curType == update) {
            mainIcon = plasmoid.configuration.iconUpdate
        }
        else if (curType == errUpdate) {
            mainIcon = plasmoid.configuration.iconError
        }
        else {
            mainIcon = plasmoid.configuration.iconNoUpdate
        }
    }
    
    function updateTooltip(subtxt) {
        //Plasmoid.toolTipMainText = txt
        Plasmoid.toolTipSubText = subtxt
        updateIcon()
    }
    
    
    function startUpdate() {
        plasmoidPassiveTimer.stop()
        if (config.updCommand.length > 0) {
            theupdate.exec(config.updCommand)
        }
    }
    
    Item {
		id: config
        property int startTimeout:  plasmoid.configuration.startTimeout*1000
		property int cycleTimeout:  plasmoid.configuration.cycleTimeout*1000
		property string chkCommand: plasmoid.configuration.chkCommand
		property string updCommand: plasmoid.configuration.updCommand
	}
    
    Plasmoid.toolTipMainText: i18n('Updates')
    Plasmoid.toolTipSubText: i18n('Looking for updates...')
    Plasmoid.toolTipTextFormat: Text.RichText

    Timer {
        id: plasmoidStartTimer
        repeat: false
        interval: config.startTimeout
        onTriggered: {
            if (config.chkCommand.length > 0) {
                executable.exec(config.chkCommand)
            }
            else {
				updateTooltip(i18n('No check script define'))
			}
			plasmoidPassiveTimer.start()
        }
    }    
    
    Timer {
        id: plasmoidPassiveTimer
        repeat: false
        interval: config.cycleTimeout
        onTriggered: {
			//print('check')
            if (config.chkCommand.length > 0) {
                executable.exec(config.chkCommand)
            }
            else {
				updateTooltip(i18n('No check script define'))
			}
			plasmoidPassiveTimer.start()
        }
    }
}
