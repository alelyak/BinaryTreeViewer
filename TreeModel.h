#ifndef TREEMODEL_H
#define TREEMODEL_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include <QFile>
#include <QDebug>

class TreeModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJsonObject treeData READ treeData NOTIFY treeDataChanged)

public:
    explicit TreeModel(QObject *parent = nullptr);

    QJsonObject treeData() const;

    Q_INVOKABLE bool loadFromFile(const QString &filePath);
    bool validateTree(const QJsonObject &node) const;
    int calculateTreeSize(const QJsonObject &node) const;

signals:
    void treeDataChanged();

private:
    QJsonObject m_treeData;
};

#endif // TREEMODEL_H
