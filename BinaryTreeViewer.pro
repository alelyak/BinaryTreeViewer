QT += qml quick quickcontrols2
CONFIG += c++17

SOURCES += \
    main.cpp \
    TreeModel.cpp

HEADERS += \
    TreeModel.h

RESOURCES += \
    qml.qrc \
    qml.qrc

# Для QML модулей
QML_IMPORT_PATH =

# Указываем, что нужно обрабатывать QML файлы
OTHER_FILES += \
    main.qml \
    TreeVisualizer.qml \
    TreeNode.qml
