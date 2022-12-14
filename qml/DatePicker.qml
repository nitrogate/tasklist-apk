import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

import BaseUI as UI

import TaskList

Item {
    id: root

    property date selectedDate: new Date()

    readonly property int day: selectedDate.getDate()
    readonly property int month: selectedDate.getMonth()
    readonly property int year: selectedDate.getFullYear()
    readonly property string dateString: year + "-" + _zeroPad(month + 1) + "-" + _zeroPad(day)

    function _zeroPad(number) { return number > 9 ? number : '0' + number }

    implicitHeight: column.implicitHeight
    implicitWidth: column.implicitWidth

    ColumnLayout {
        id: column

        spacing: 0
        anchors.fill: parent

        Rectangle {
            implicitHeight: monthRow.implicitHeight
            color: Material.primary

            Layout.fillWidth: true

            RowLayout {
                id: monthRow

                spacing: 6
                width: parent.width

                ToolButton {
                    leftPadding: 12
                    rightPadding: 12
                    icon.source: UI.Icons.keyboard_arrow_left
                    icon.color: UI.Style.textOnPrimary
                    onClicked: {
                        if (monthGrid.month > 0) {
                            monthGrid.month--
                        } else {
                            monthGrid.month = 11
                            monthGrid.year--
                        }
                    }
                }

                UI.LabelTitle {
                    text: Qt.locale(Settings.country).monthName(monthGrid.month) + " " + monthGrid.year
                    elide: Text.ElideRight
                    color: UI.Style.textOnPrimary
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                }

                ToolButton {
                    leftPadding: 12
                    rightPadding: 12
                    icon.source: UI.Icons.keyboard_arrow_right
                    icon.color: UI.Style.textOnPrimary
                    onClicked: {
                        if (monthGrid.month < 11) {
                            monthGrid.month++
                        } else {
                            monthGrid.month = 0
                            monthGrid.year++
                        }
                    }
                }
            }
        }

        DayOfWeekRow {
            id: dayOfWeekRow

            leftPadding: 24
            rightPadding: 24
            Layout.fillWidth: true
            font.bold: false

            locale: Qt.locale(Settings.country)

            delegate: LabelBodySecondary {
                text: model.shortName
                font: dayOfWeekRow.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        MonthGrid {
            id: monthGrid

            rightPadding: 24
            leftPadding: 24
            Layout.fillWidth: true

            month: root.month
            year: root.year

            locale: Qt.locale(Settings.country)

            onClicked: function(d) {
                // Important: check the month to avoid clicking on days outside where opacity 0
                if (d.getMonth() === monthGrid.month) {
                    root.selectedDate = d
                    console.log("tapped on a date ")
                } else {
                    console.log("outside valid month " + d.getMonth())
                }
            }

            delegate: Label {
                id: dayLabel

                readonly property bool selected:
                    model.day === root.day
                    && model.month === root.month
                    && model.year === root.year

                text: model.day
                font.bold: model.today ? true : false
                font.pixelSize: UI.Style.fontSizeTitle
                opacity: model.month === monthGrid.month ? 1 : 0.3
                color: selected
                    ? UI.Style.textOnPrimary
                    : (model.today ? UI.Style.accentColor : Material.foreground)
                minimumPointSize: 8
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                background: Rectangle {
                    anchors.centerIn: parent
                    width: Math.min(parent.height + 2, parent.width + 2)
                    height: Math.min(parent.height + 2, parent.width + 2)
                    radius: width / 2
                    color: parent.selected ? UI.Style.primaryColor : "transparent"
                }
            }
        }
    }
}
