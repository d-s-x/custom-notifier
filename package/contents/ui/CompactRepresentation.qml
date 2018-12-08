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
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: compactRepresentation

    property string customIconSource: main.curType==main.noUpdate? plasmoid.configuration.iconNoUpdate.substring(0, 2).localeCompare("..")==0?Qt.resolvedUrl(".")+plasmoid.configuration.iconNoUpdate:plasmoid.configuration.iconNoUpdate:main.curType==main.update?plasmoid.configuration.iconUpdate.substring(0, 2).localeCompare("..")==0?Qt.resolvedUrl(".")+plasmoid.configuration.iconUpdate:plasmoid.configuration.iconUpdate:plasmoid.configuration.iconError.substring(0, 2).localeCompare("..")==0?Qt.resolvedUrl(".")+plasmoid.configuration.iconError:plasmoid.configuration.iconError
     
    PlasmaCore.IconItem {
        id: customIcon
        anchors.fill: parent
        source: customIconSource
    }

    MouseArea {
        id: mouseArea
        acceptedButtons: Qt.LeftButton
        anchors.fill: parent
        
        onClicked: {
            startUpdate()
        }
    }
}
