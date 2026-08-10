/****************************************************************************
** Generated QML type registration code
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#if __has_include(<filewatcher.h>)
#  include <filewatcher.h>
#endif
#if __has_include(<spineitem.h>)
#  include <spineitem.h>
#endif


#if !defined(QT_STATIC)
#define Q_QMLTYPE_EXPORT Q_DECL_EXPORT
#else
#define Q_QMLTYPE_EXPORT
#endif
Q_QMLTYPE_EXPORT void qml_register_types_SpineQml()
{
    QT_WARNING_PUSH QT_WARNING_DISABLE_DEPRECATED
    qmlRegisterTypesAndRevisions<FileWatcher>("SpineQml", 1);
    QMetaType::fromType<QQuickFramebufferObject *>().id();
    qmlRegisterTypesAndRevisions<SpineItem>("SpineQml", 1);
    qmlRegisterAnonymousType<QQuickItem, 254>("SpineQml", 1);
    QT_WARNING_POP
    qmlRegisterModule("SpineQml", 1, 0);
}

static const QQmlModuleRegistration spineQmlRegistration("SpineQml", qml_register_types_SpineQml);
