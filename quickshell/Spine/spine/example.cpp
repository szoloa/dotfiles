// example.cpp
#include <QApplication>
#include "SpineWidget.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    SpineWidget widget;
    widget.resize(800, 600);
    widget.show();
    return app.exec();
}
