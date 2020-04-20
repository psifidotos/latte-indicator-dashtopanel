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

import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0

import org.kde.latte.components 1.0 as LatteComponents

ColumnLayout {
    Layout.fillWidth: true

    readonly property bool deprecatedPropertiesAreHidden: dialog && dialog.hasOwnProperty("deprecatedOptionsAreHidden") && dialog.deprecatedOptionsAreHidden

    LatteComponents.SubHeader {
        text: i18n("Style")
    }

    ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: 2

            readonly property int style: indicator.configuration.style

            readonly property int buttonsCount: 3
            readonly property int buttonSize: (dialog.optionsWidth - (spacing * buttonsCount-1)) / buttonsCount

            ExclusiveGroup {
                id: styleGroup
                onCurrentChanged: {
                    if (current.checked) {
                        indicator.configuration.style = current.style;
                    }
                }
            }

            PlasmaComponents.Button {
                Layout.minimumWidth: parent.buttonSize
                Layout.maximumWidth: Layout.minimumWidth

                text: i18nc("metro style","Metro")
                checked: parent.style === style
                checkable: true
                exclusiveGroup: styleGroup
                tooltip: i18n("Use Metro style for item states")

                readonly property int style: 0 /*Metro*/
            }

            PlasmaComponents.Button {
                Layout.minimumWidth: parent.buttonSize
                Layout.maximumWidth: Layout.minimumWidth

                text: i18nc("ciliora style", "Ciliora")
                checked: parent.style === style
                checkable: true
                exclusiveGroup: styleGroup
                tooltip: i18n("Use Ciliora style for item states")

                readonly property int style: 1 /*Ciliora*/
            }

            PlasmaComponents.Button {
                Layout.minimumWidth: parent.buttonSize
                Layout.maximumWidth: Layout.minimumWidth

                text: i18nc("dashes style", "Dashes")
                checked: parent.style === style
                checkable: true
                exclusiveGroup: styleGroup
                tooltip: i18n("Use Dashes style for item states")

                readonly property int style: 2 /*Dashes*/
            }
        }
    }

    LatteComponents.SubHeader {
        text: i18n("Background")
    }

    ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: units.smallSpacing
            visible: deprecatedPropertiesAreHidden

            PlasmaComponents.Label {
                text: i18n("Length")
                horizontalAlignment: Text.AlignLeft
            }

            LatteComponents.Slider {
                id: lengthIntMarginSlider
                Layout.fillWidth: true

                value: Math.round(indicator.configuration.lengthPadding * 100)
                from: 3
                to: maxMargin
                stepSize: 1
                wheelEnabled: false

                readonly property int maxMargin: 80

                onPressedChanged: {
                    if (!pressed) {
                        indicator.configuration.lengthPadding = value / 100;
                    }
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%0 %").arg(currentValue)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4

                readonly property int currentValue: lengthIntMarginSlider.value
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 2


            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Max Opacity")
            }

            LatteComponents.Slider {
                id: maxOpacitySlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.maxBackgroundOpacity * 100
                from: 20
                to: 100
                stepSize: 5
                wheelEnabled: false

                function updateMaxOpacity() {
                    if (!pressed) {
                        indicator.configuration.maxBackgroundOpacity = value/100;
                    }
                }

                onPressedChanged: {
                    updateMaxOpacity();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateMaxOpacity);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateMaxOpacity);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%0 %").arg(maxOpacitySlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 2


            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Line Thickness")
            }

            LatteComponents.Slider {
                id: lineSlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.lineThickness * 100
                from: 2
                to: 20
                stepSize: 1
                wheelEnabled: false

                function updateLineThickness() {
                    if (!pressed) {
                        indicator.configuration.lineThickness = value/100;
                    }
                }

                onPressedChanged: {
                    updateLineThickness();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateLineThickness);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateLineThickness);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%0 %").arg(lineSlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }
    }

    LatteComponents.SubHeader {
        text: i18n("Options")
    }

    LatteComponents.CheckBoxesColumn {
        Layout.fillWidth: true

        LatteComponents.CheckBox {
            Layout.maximumWidth: dialog.optionsWidth
            text: i18n("Show indicators for applets")
            checked: indicator.configuration.enabledForApplets
            tooltip: i18n("Indicators are shown for applets")
            visible: deprecatedPropertiesAreHidden

            onClicked: {
                indicator.configuration.enabledForApplets = !indicator.configuration.enabledForApplets;
            }
        }

        LatteComponents.CheckBox {
            id: shapesBorder
            Layout.maximumWidth: dialog.optionsWidth
            text: i18n("Reverse boxes position")
            checked: indicator.configuration.isReversed

            onClicked: {
                indicator.configuration.isReversed = !indicator.configuration.isReversed;
            }
        }
    }
}
