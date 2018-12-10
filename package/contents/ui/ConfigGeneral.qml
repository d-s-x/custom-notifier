/*
 * Copyright 2015  Martin Kotelnik <clearmartin@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {

	//showAppletVersion: true
	
    property alias cfg_startTimeout:    startTimeout.value
    property alias cfg_cycleTimeout:    cycleTimeout.value
    property alias cfg_chkCommand:      chkCommand.text
    property alias cfg_updCommand:      updCommand.text
    property alias cfg_useDefaultIcons: useDefaultIcons.checked
    property string cfg_iconNoUpdate:     plasmoid.configuration.iconNoUpdate
    property string cfg_iconUpdate:   plasmoid.configuration.iconUpdate
    property string cfg_iconError:      plasmoid.configuration.iconError


	
    GridLayout {
        Layout.fillWidth: true
        columns: 2
        
        Label {
			text: i18n('Plasmoid version') + ': 1.0'
			font.bold: true
			Layout.alignment: Qt.AlignRight
		}

		Label {
			text: '<a href="https://gitlab.com/yaute74/custom-notifier.git">'+i18n("Help")+'</a>'
			linkColor: PlasmaCore.ColorScope.highlightColor
			onLinkActivated: Qt.openUrlExternally(link)
			MouseArea {
				anchors.fill: parent
				acceptedButtons: Qt.NoButton // we don't want to eat clicks on the Text
				cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
			}
		}

		
		
        Label {
            text: i18n("Timeout before first check (sec)")
            Layout.alignment: Qt.AlignRight
        }
        SpinBox {
            id: startTimeout
            decimals: 0
            stepSize: 1
            minimumValue: 1
            maximumValue: 86400
        }
        
        Label {
            text: i18n("Timeout between each checks (sec)")
            Layout.alignment: Qt.AlignRight
        }
        SpinBox {
            id: cycleTimeout
            decimals: 0
            stepSize: 1
            minimumValue: 1
            maximumValue: 86400
        }        
        
        Label {
            text: i18n("Script to check updates:")
            Layout.alignment: Qt.AlignRight
        }
        TextField {
            id: chkCommand
            placeholderText: i18n('[Script path]')
            Layout.preferredWidth: 400
        }
        
        Label {
            text: i18n("Script to update:")
            Layout.alignment: Qt.AlignRight
        }
        TextField {
            id: updCommand
            placeholderText: "/usr/bin/konsole -e " +i18n("[Script path]")
            Layout.preferredWidth: 400
        }        
        
        CheckBox {
            id: useDefaultIcons
            text: i18n('Use default icons')
            Layout.columnSpan: 2
        }
        
        Label {
            text: i18n("System up to date")
            Layout.alignment: Qt.AlignRight
        }

        IconPicker {
            currentIcon: cfg_iconNoUpdate
            defaultIcon: '../images/noupdate.svg'
            onIconChanged: cfg_iconNoUpdate = iconName
            enabled: !useDefaultIcons.checked
        }

        Label {
            text: i18n("Updates available")
            Layout.alignment: Qt.AlignRight
        }

        IconPicker {
            currentIcon: cfg_iconUpdate
            defaultIcon: '../images/update.svg'
            onIconChanged: cfg_iconUpdate = iconName
            enabled: !useDefaultIcons.checked
        }

        Label {
            text: i18n("Script in error")
            Layout.alignment: Qt.AlignRight
        }

        IconPicker {
            currentIcon: cfg_iconError
            defaultIcon: '../images/error.svg'
            onIconChanged: cfg_iconError = iconName
            enabled: !useDefaultIcons.checked
        }
    }
}
