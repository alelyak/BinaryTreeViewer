#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "TreeModel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    // Регистрируем наш TreeModel как QML тип
    qmlRegisterType<TreeModel>("TreeModel", 1, 0, "TreeModel");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
