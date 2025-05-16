#include "TreeModel.h"
#include <QFile>
#include <QJsonDocument>
#include <QDebug>
#include <QUrl> // Добавляем для обработки file:/// путей
#include <QDir>

TreeModel::TreeModel(QObject *parent) : QObject(parent)
{
}

QJsonObject TreeModel::treeData() const
{
    return m_treeData;
}

bool TreeModel::loadFromFile(const QString &filePath)
{
    QString cleanPath = filePath;

        // Удаление всех вариантов file://
    cleanPath = cleanPath.replace("file:///", "").replace("file://", "").replace("file:/", "");

        // Удаление лишних слэшей в начале для Windows
    if (cleanPath.startsWith("/") && cleanPath.length() > 3 && cleanPath[2] == ':') {
        cleanPath = cleanPath.mid(1);
        }

    qDebug() << "Final file path:" << cleanPath;

    QFileInfo fileInfo(cleanPath);
    if (!fileInfo.exists()) {
        qWarning() << "File does not exist at absolute path:" << fileInfo.absoluteFilePath();
        qWarning() << "Current working directory:" << QDir::currentPath();
        return false;
    }

    // 3. Открытие файла
    QFile file(cleanPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Could not open file:" << cleanPath << "Error:" << file.errorString();
        return false;
    }

    // 4. Чтение данных
    QByteArray data = file.readAll();
    file.close();

    // 5. Парсинг JSON
    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "JSON parse error at offset" << parseError.offset
                  << ":" << parseError.errorString();
        return false;
    }

    if (!doc.isObject()) {
        qWarning() << "JSON document is not an object";
        return false;
    }

    // 6. Сохранение данных и уведомление об изменении
    m_treeData = doc.object();
    emit treeDataChanged();

    qDebug() << "Successfully loaded JSON file:" << cleanPath;
    return true;
}

bool TreeModel::validateTree(const QJsonObject &node) const
{
    if (!node.contains("value")) return false;

    if (node.contains("left")) {
        if (!node["left"].isObject() && !node["left"].isNull())
            return false;
        if (node["left"].isObject() && !validateTree(node["left"].toObject()))
            return false;
    }

    if (node.contains("right")) {
        if (!node["right"].isObject() && !node["right"].isNull())
            return false;
        if (node["right"].isObject() && !validateTree(node["right"].toObject()))
            return false;
    }

    return true;
}

int TreeModel::calculateTreeSize(const QJsonObject &node) const
{
    if (node.isEmpty()) return 0;

    int size = 1; // current node
    if (node.contains("left") && node["left"].isObject())
        size += calculateTreeSize(node["left"].toObject());
    if (node.contains("right") && node["right"].isObject())
        size += calculateTreeSize(node["right"].toObject());

    return size;
}
