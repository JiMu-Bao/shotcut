/*
 * Copyright (c) 2012 Meltytech, LLC
 * Author: Dan Dennedy <dan@dennedy.org>
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

#ifndef COLORPRODUCERWIDGET_H
#define COLORPRODUCERWIDGET_H

#include <QWidget>
#include "abstractproducerwidget.h"

namespace Ui {
    class ColorProducerWidget;
}

class ColorProducerWidget : public QWidget, public AbstractProducerWidget
{
    Q_OBJECT

public:
    explicit ColorProducerWidget(QWidget *parent = 0);
    ~ColorProducerWidget();

    QString producerName() const
        { return "color"; }
    Mlt::Properties* mltProperties();
    void load(Mlt::Properties&);

private slots:
    void on_colorButton_clicked();
    
private:
    Ui::ColorProducerWidget *ui;
};

#endif // COLORPRODUCERWIDGET_H
