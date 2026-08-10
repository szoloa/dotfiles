/****************************************************************************
** Meta object code from reading C++ file 'spineitem.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../spineqml/spineitem.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'spineitem.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.11.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN9SpineItemE_t {};
} // unnamed namespace

template <> constexpr inline auto SpineItem::qt_create_metaobjectdata<qt_meta_tag_ZN9SpineItemE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "SpineItem",
        "QML.Element",
        "auto",
        "atlasUrlChanged",
        "",
        "skeletonUrlChanged",
        "animationNameChanged",
        "scaleChanged",
        "autoPlayChanged",
        "timeScaleChanged",
        "loadedChanged",
        "queuedAnimationChanged",
        "mixDurationChanged",
        "characterChanged",
        "dataRootChanged",
        "loadError",
        "message",
        "playAnimation",
        "name",
        "loop",
        "queueAnimation",
        "delay",
        "clearTrack",
        "trackIndex",
        "reloadData",
        "atlasUrl",
        "skeletonUrl",
        "animationName",
        "scale",
        "autoPlay",
        "timeScale",
        "loaded",
        "queuedAnimation",
        "mixDuration",
        "character",
        "dataRoot"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'atlasUrlChanged'
        QtMocHelpers::SignalData<void()>(3, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'skeletonUrlChanged'
        QtMocHelpers::SignalData<void()>(5, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'animationNameChanged'
        QtMocHelpers::SignalData<void()>(6, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'scaleChanged'
        QtMocHelpers::SignalData<void()>(7, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'autoPlayChanged'
        QtMocHelpers::SignalData<void()>(8, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'timeScaleChanged'
        QtMocHelpers::SignalData<void()>(9, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'loadedChanged'
        QtMocHelpers::SignalData<void()>(10, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'queuedAnimationChanged'
        QtMocHelpers::SignalData<void()>(11, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'mixDurationChanged'
        QtMocHelpers::SignalData<void()>(12, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'characterChanged'
        QtMocHelpers::SignalData<void()>(13, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'dataRootChanged'
        QtMocHelpers::SignalData<void()>(14, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'loadError'
        QtMocHelpers::SignalData<void(const QString &)>(15, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 16 },
        }}),
        // Method 'playAnimation'
        QtMocHelpers::MethodData<void(const QString &, bool)>(17, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 18 }, { QMetaType::Bool, 19 },
        }}),
        // Method 'playAnimation'
        QtMocHelpers::MethodData<void(const QString &)>(17, 4, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 18 },
        }}),
        // Method 'queueAnimation'
        QtMocHelpers::MethodData<void(const QString &, bool, float)>(20, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 18 }, { QMetaType::Bool, 19 }, { QMetaType::Float, 21 },
        }}),
        // Method 'queueAnimation'
        QtMocHelpers::MethodData<void(const QString &, bool)>(20, 4, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 18 }, { QMetaType::Bool, 19 },
        }}),
        // Method 'queueAnimation'
        QtMocHelpers::MethodData<void(const QString &)>(20, 4, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 18 },
        }}),
        // Method 'clearTrack'
        QtMocHelpers::MethodData<void(int)>(22, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 23 },
        }}),
        // Method 'clearTrack'
        QtMocHelpers::MethodData<void()>(22, 4, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void),
        // Method 'reloadData'
        QtMocHelpers::MethodData<void()>(24, 4, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'atlasUrl'
        QtMocHelpers::PropertyData<QString>(25, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 0),
        // property 'skeletonUrl'
        QtMocHelpers::PropertyData<QString>(26, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 1),
        // property 'animationName'
        QtMocHelpers::PropertyData<QString>(27, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 2),
        // property 'scale'
        QtMocHelpers::PropertyData<qreal>(28, QMetaType::QReal, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 3),
        // property 'autoPlay'
        QtMocHelpers::PropertyData<bool>(29, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 4),
        // property 'timeScale'
        QtMocHelpers::PropertyData<qreal>(30, QMetaType::QReal, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 5),
        // property 'loaded'
        QtMocHelpers::PropertyData<bool>(31, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Final, 6),
        // property 'queuedAnimation'
        QtMocHelpers::PropertyData<QString>(32, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 7),
        // property 'mixDuration'
        QtMocHelpers::PropertyData<qreal>(33, QMetaType::QReal, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 8),
        // property 'character'
        QtMocHelpers::PropertyData<QString>(34, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 9),
        // property 'dataRoot'
        QtMocHelpers::PropertyData<QString>(35, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet | QMC::Final, 10),
    };
    QtMocHelpers::UintData qt_enums {
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
    });
    return QtMocHelpers::metaObjectData<SpineItem, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject SpineItem::staticMetaObject = { {
    QMetaObject::SuperData::link<QQuickFramebufferObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9SpineItemE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9SpineItemE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN9SpineItemE_t>.metaTypes,
    nullptr
} };

void SpineItem::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<SpineItem *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->atlasUrlChanged(); break;
        case 1: _t->skeletonUrlChanged(); break;
        case 2: _t->animationNameChanged(); break;
        case 3: _t->scaleChanged(); break;
        case 4: _t->autoPlayChanged(); break;
        case 5: _t->timeScaleChanged(); break;
        case 6: _t->loadedChanged(); break;
        case 7: _t->queuedAnimationChanged(); break;
        case 8: _t->mixDurationChanged(); break;
        case 9: _t->characterChanged(); break;
        case 10: _t->dataRootChanged(); break;
        case 11: _t->loadError((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 12: _t->playAnimation((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<bool>>(_a[2]))); break;
        case 13: _t->playAnimation((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 14: _t->queueAnimation((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<bool>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[3]))); break;
        case 15: _t->queueAnimation((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<bool>>(_a[2]))); break;
        case 16: _t->queueAnimation((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 17: _t->clearTrack((*reinterpret_cast<std::add_pointer_t<int>>(_a[1]))); break;
        case 18: _t->clearTrack(); break;
        case 19: _t->reloadData(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)()>(_a, &SpineItem::atlasUrlChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)()>(_a, &SpineItem::skeletonUrlChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)()>(_a, &SpineItem::animationNameChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)()>(_a, &SpineItem::scaleChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)()>(_a, &SpineItem::autoPlayChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)()>(_a, &SpineItem::timeScaleChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)()>(_a, &SpineItem::loadedChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)()>(_a, &SpineItem::queuedAnimationChanged, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)()>(_a, &SpineItem::mixDurationChanged, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)()>(_a, &SpineItem::characterChanged, 9))
            return;
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)()>(_a, &SpineItem::dataRootChanged, 10))
            return;
        if (QtMocHelpers::indexOfMethod<void (SpineItem::*)(const QString & )>(_a, &SpineItem::loadError, 11))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QString*>(_v) = _t->atlasUrl(); break;
        case 1: *reinterpret_cast<QString*>(_v) = _t->skeletonUrl(); break;
        case 2: *reinterpret_cast<QString*>(_v) = _t->animationName(); break;
        case 3: *reinterpret_cast<qreal*>(_v) = _t->scale(); break;
        case 4: *reinterpret_cast<bool*>(_v) = _t->autoPlay(); break;
        case 5: *reinterpret_cast<qreal*>(_v) = _t->timeScale(); break;
        case 6: *reinterpret_cast<bool*>(_v) = _t->isLoaded(); break;
        case 7: *reinterpret_cast<QString*>(_v) = _t->queuedAnimation(); break;
        case 8: *reinterpret_cast<qreal*>(_v) = _t->mixDuration(); break;
        case 9: *reinterpret_cast<QString*>(_v) = _t->character(); break;
        case 10: *reinterpret_cast<QString*>(_v) = _t->dataRoot(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setAtlasUrl(*reinterpret_cast<QString*>(_v)); break;
        case 1: _t->setSkeletonUrl(*reinterpret_cast<QString*>(_v)); break;
        case 2: _t->setAnimationName(*reinterpret_cast<QString*>(_v)); break;
        case 3: _t->setScale(*reinterpret_cast<qreal*>(_v)); break;
        case 4: _t->setAutoPlay(*reinterpret_cast<bool*>(_v)); break;
        case 5: _t->setTimeScale(*reinterpret_cast<qreal*>(_v)); break;
        case 7: _t->setQueuedAnimation(*reinterpret_cast<QString*>(_v)); break;
        case 8: _t->setMixDuration(*reinterpret_cast<qreal*>(_v)); break;
        case 9: _t->setCharacter(*reinterpret_cast<QString*>(_v)); break;
        case 10: _t->setDataRoot(*reinterpret_cast<QString*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *SpineItem::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SpineItem::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9SpineItemE_t>.strings))
        return static_cast<void*>(this);
    return QQuickFramebufferObject::qt_metacast(_clname);
}

int SpineItem::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QQuickFramebufferObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 20)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 20;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 20)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 20;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    }
    return _id;
}

// SIGNAL 0
void SpineItem::atlasUrlChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void SpineItem::skeletonUrlChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void SpineItem::animationNameChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void SpineItem::scaleChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void SpineItem::autoPlayChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void SpineItem::timeScaleChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void SpineItem::loadedChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void SpineItem::queuedAnimationChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}

// SIGNAL 8
void SpineItem::mixDurationChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 8, nullptr);
}

// SIGNAL 9
void SpineItem::characterChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 9, nullptr);
}

// SIGNAL 10
void SpineItem::dataRootChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 10, nullptr);
}

// SIGNAL 11
void SpineItem::loadError(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 11, nullptr, _t1);
}
QT_WARNING_POP
