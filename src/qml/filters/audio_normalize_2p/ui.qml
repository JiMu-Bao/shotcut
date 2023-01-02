/*
 * Copyright (c) 2013-2022 Meltytech, LLC
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs
import QtQuick.Layouts 1.12
import Shotcut.Controls 1.0 as Shotcut

Item {
    function setStatus(inProgress) {
        if (inProgress) {
            status.text = qsTr('Analyzing...');
            results.text = '--';
            normalizationGain.text = '--';
        } else if (filter.get("results").length > 0) {
            status.text = qsTr('Analysis complete.');
            var loudnessValue = filter.get("results").split('\t')[0].split('L:')[1];
            loudnessValue = Math.round(loudnessValue * 100) / 100;
            results.text = qsTr('%1 LUFS').arg(loudnessValue);
            var gainValue = programSlider.value - loudnessValue;
            gainValue = Math.round(gainValue * 100) / 100;
            normalizationGain.text = qsTr('%1 dB').arg(gainValue);
        } else {
            status.text = qsTr('Click "Analyze" to use this filter.');
            results.text = '--';
            normalizationGain.text = '--';
        }
    }

    width: 350
    height: 50
    Component.onCompleted: {
        setStatus(false);
    }

    Connections {
        function onAnalyzeFinished() {
            setStatus(false);
            button.enabled = true;
            programSlider.enabled = true;
        }

        target: filter
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 8
        columns: 3

        Label {
            Layout.alignment: Qt.AlignRight
            text: qsTr('Target Loudness')
        }

        Shotcut.SliderSpinner {
            id: programSlider

            minimumValue: -50
            maximumValue: -10
            decimals: 1
            suffix: ' LUFS'
            spinnerWidth: 100
            value: filter ? filter.getDouble('program') : 0
            onValueChanged: {
                if (filter) {
                    filter.set('program', value);
                    setStatus(false);
                }
            }
        }

        Shotcut.UndoButton {
            onClicked: programSlider.value = -23
        }

        Label {
        }

        Shotcut.Button {
            id: button

            Layout.columnSpan: 2
            text: qsTr('Analyze')
            onClicked: {
                button.enabled = false;
                programSlider.enabled = false;
                setStatus(true);
                filter.analyze(true);
            }
        }

        Rectangle {
            Layout.columnSpan: 3
            Layout.fillWidth: true
            Layout.minimumHeight: 12
            color: 'transparent'

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 2
                radius: 2
                color: activePalette.text
            }
        }

        Label {
            id: status

            Layout.columnSpan: 3
        }

        Label {
            text: qsTr('Detected Loudness:')
            Layout.alignment: Qt.AlignRight

            Shotcut.HoverTip {
                text: qsTr('The loudness calculated by the analysis.')
            }
        }

        Label {
            id: results

            Layout.columnSpan: 2
        }

        Label {
            text: qsTr('Normalization Gain:')
            Layout.alignment: Qt.AlignRight

            Shotcut.HoverTip {
                text: qsTr('The gain applied to normalize to the Target Loudness.')
            }
        }

        Label {
            id: normalizationGain

            Layout.columnSpan: 2
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
