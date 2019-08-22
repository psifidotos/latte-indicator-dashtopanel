/*
*  Copyright 2019  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.latte.components 1.0 as LatteComponents

LatteComponents.IndicatorItem {
    id: root

    needsIconColors: true
    minLengthPadding: 0.03

    readonly property int thickness: isVertical ? width : height

    readonly property bool isHorizontal: plasmoid.formFactor === PlasmaCore.Types.Horizontal
    readonly property bool isVertical: plasmoid.formFactor === PlasmaCore.Types.Vertical

    readonly property bool isMetroStyle: indicator.configuration.style === 0
    readonly property bool isCilioraStyle: indicator.configuration.style === 1
    readonly property bool isDashesStyle: indicator.configuration.style === 2

    //! Background
    Rectangle {
        anchors.fill: parent
        color: indicator.palette.textColor

        readonly property real opacityStep: indicator.configuration.maxBackgroundOpacity > 0.6 ? 0.15 : 0.1

        opacity: {
            if (indicator.isHovered && indicator.hasActive) {
                return indicator.configuration.maxBackgroundOpacity;
            } else if (indicator.hasActive) {
                return indicator.configuration.maxBackgroundOpacity - 2*opacityStep;
            } else if (indicator.isHovered) {
                return indicator.configuration.maxBackgroundOpacity - 3*opacityStep;
            }

            return 0;
        }
    }

    GridLayout {
        id: boxesLayout

        width: isDashesStyle && isHorizontal ? undefined : (isHorizontal ? parent.width : undefined)
        height: isDashesStyle && isVertical ? undefined: (isVertical ? parent.height : undefined)

        rows: isHorizontal ? 1 : -1
        columns: isVertical ? 1 : -1

        rowSpacing: isVertical ? spacing : 0
        columnSpacing: isHorizontal ? spacing : 0

        readonly property int spacing: indicator.currentIconSize * 0.08
        readonly property int thickness: Math.max(indicator.currentIconSize * 0.1, 2)

        readonly property int minLength: isCilioraStyle ? thickness : 2*thickness

        Repeater {
            model: {
                if (indicator.isApplet) {
                    return indicator.isActive ? 1 : 0
                }

                return Math.min(indicator.windowsCount, maxStates);
            }

            readonly property int maxStates: isMetroStyle ? 2 : 4

            Rectangle {
                id: stateRect
                Layout.fillWidth: isHorizontal && isFirst && !isDashesStyle
                Layout.fillHeight: isVertical && isFirst && !isDashesStyle

                Layout.minimumWidth: isHorizontal ? boxesLayout.minLength : boxesLayout.thickness
                Layout.maximumWidth: isHorizontal && isFirst ? -1 : (isHorizontal ? boxesLayout.minLength : boxesLayout.thickness)

                Layout.minimumHeight: isHorizontal ? boxesLayout.thickness : boxesLayout.minLength
                Layout.maximumHeight: isVertical && isFirst ? -1 : (isVertical ? boxesLayout.minLength : boxesLayout.thickness)

                color: isMetroStyle && !isFirst ? indicator.iconBackgroundColor : indicator.iconGlowColor

                readonly property bool isFirst: index === 0
            }
        }
    }

    states:[
        State {
            name: "bottom"
            when: (plasmoid.location === PlasmaCore.Types.BottomEdge && !indicator.configuration.isReversed)
                  || (plasmoid.location === PlasmaCore.Types.TopEdge && indicator.configuration.isReversed)

            AnchorChanges {
                target: boxesLayout
                anchors{ top:undefined; bottom:parent.bottom; left:undefined; right:undefined;
                    horizontalCenter:parent.horizontalCenter; verticalCenter:undefined}
            }
        },
        State {
            name: "left"
            when: (plasmoid.location === PlasmaCore.Types.LeftEdge && !indicator.configuration.isReversed)
                  || (plasmoid.location === PlasmaCore.Types.RightEdge && indicator.configuration.isReversed)

            AnchorChanges {
                target: boxesLayout
                anchors{ top:undefined; bottom:undefined; left:parent.left; right:undefined;
                    horizontalCenter:undefined; verticalCenter:parent.verticalCenter}
            }
        },
        State {
            name: "right"
            when: (plasmoid.location === PlasmaCore.Types.RightEdge && !indicator.configuration.isReversed)
                  || (plasmoid.location === PlasmaCore.Types.LeftEdge && indicator.configuration.isReversed)

            AnchorChanges {
                target: boxesLayout
                anchors{ top:undefined; bottom:undefined; left:undefined; right:parent.right;
                    horizontalCenter:undefined; verticalCenter:parent.verticalCenter}
            }
        },
        State {
            name: "top"
            when: (plasmoid.location === PlasmaCore.Types.TopEdge && !indicator.configuration.isReversed)
                  || (plasmoid.location === PlasmaCore.Types.BottomEdge && indicator.configuration.isReversed)

            AnchorChanges {
                target: boxesLayout
                anchors{ top:parent.top; bottom:undefined; left:undefined; right:undefined;
                    horizontalCenter:parent.horizontalCenter; verticalCenter:undefined}
            }
        }
    ]

}
