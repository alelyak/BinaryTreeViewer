#include "TreeModel.h"

TreeModel::TreeModel(QObject *parent) : QObject(parent)
{
}

QJsonObject TreeModel::treeData() const
{
    return m_treeData;
}

bool TreeModel::loadFromFile(const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Could not open file:" << filePath;
        return false;
    }

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);

    if (doc.isNull()) {
        qWarning() << "Invalid JSON file:" << filePath;
        return false;
    }

    m_treeData = doc.object();
    emit treeDataChanged();
    return true;
}
