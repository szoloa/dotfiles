#ifndef FILEWATCHER_H
#define FILEWATCHER_H

#include <QObject>
#include <QFileSystemWatcher>
#include <QFile>
#include <QDebug>
#include <QtQml/qqmlregistration.h>

class FileWatcher : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString filePath READ filePath WRITE setFilePath NOTIFY filePathChanged FINAL)
    Q_PROPERTY(QString text READ text NOTIFY textChanged FINAL)
    QML_ELEMENT

public:
    explicit FileWatcher(QObject *parent = nullptr) : QObject(parent) {}

    QString filePath() const { return m_filePath; }
    void setFilePath(const QString &path) {
        if (m_filePath != path) {
            m_filePath = path;
            emit filePathChanged();
            startWatching();
        }
    }

    QString text() const { return m_text; }

    Q_INVOKABLE void startWatching() {
        if (m_filePath.isEmpty()) return;
        delete m_watcher;
        m_watcher = new QFileSystemWatcher({m_filePath}, this);
        connect(m_watcher, &QFileSystemWatcher::fileChanged,
                this, &FileWatcher::onFileChanged);
        qDebug("FileWatcher: watching %s", qPrintable(m_filePath));
    }

signals:
    void filePathChanged();
    void textChanged();

private slots:
    void onFileChanged() {
        QFile f(m_filePath);
        if (f.open(QIODevice::ReadOnly)) {
            QString newText = QString::fromUtf8(f.readAll()).trimmed();
            if (!newText.isEmpty() && newText != m_text) {
                m_text = newText;
                qDebug("FileWatcher: text changed to '%s'", qPrintable(m_text));
                emit textChanged();
            }
        }
        // Re-add (watcher auto-removes after change)
        if (m_watcher) m_watcher->addPath(m_filePath);
    }

private:
    QFileSystemWatcher *m_watcher = nullptr;
    QString m_filePath;
    QString m_text;
};

#endif
