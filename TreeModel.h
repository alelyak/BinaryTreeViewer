#ifndef TREEMODEL_H
#define TREEMODEL_H

#include <QMainWindow>

class TreeModel : public QMainWindow
{
    Q_OBJECT

public:
    TreeModel(QWidget *parent = nullptr);
    ~TreeModel();
};
#endif // TREEMODEL_H
