QT += quick serialport widgets quickcontrols2 svg

include(../qflipper_common.pri)

TARGET = $$NAME
DESTDIR = $$OUT_PWD/..

CONFIG += c++11

SOURCES += \
        application.cpp \
        applicationupdater.cpp \
        applicationupdateregistry.cpp \
        main.cpp \
        qtsingleapplication/qtlocalpeer.cpp \
        qtsingleapplication/qtlockedfile.cpp \
        qtsingleapplication/qtlockedfile_unix.cpp \
        qtsingleapplication/qtlockedfile_win.cpp \
        qtsingleapplication/qtsingleapplication.cpp \
        qtsingleapplication/qtsinglecoreapplication.cpp \
        screencanvas.cpp \
        themedimageprovider.cpp \
        systemfiledialog.cpp

RESOURCES += qml.qrc

TRANSLATIONS += \
    translations/en_US.ts

CONFIG += lrelease
CONFIG += embed_translations

QML_IMPORT_PATH += $$PWD/imports

unix:!macx {
    QTPLUGIN += qxdgdesktopportal
    QTPLUGIN.platforms += qxcb qwayland-egl qwayland-generic
}

win32:!win32-g++ {
    PRE_TARGETDEPS += \
        $$OUT_PWD/../backend/backend.lib \
        $$OUT_PWD/../dfu/dfu.lib

} else:unix|win32-g++ {
    PRE_TARGETDEPS += \
        $$OUT_PWD/../backend/libbackend.a \
        $$OUT_PWD/../dfu/libdfu.a

    contains(CONFIG, static): PRE_TARGETDEPS += \
        $$OUT_PWD/../plugins/libflipperproto0.a \
        $$OUT_PWD/../3rdparty/lib3rdparty.a
}

unix|win32 {
    LIBS += \
        -L$$OUT_PWD/../backend/ -lbackend \
        -L$$OUT_PWD/../dfu/ -ldfu

    contains(CONFIG, static): LIBS += \
        -L$$OUT_PWD/../plugins/ -lflipperproto0 \
        -L$$OUT_PWD/../3rdparty/ -l3rdparty
}

win32 {
    equals(HAS_VERSION, 0) {
        # The Windows manifest VERSION must be numeric (x.y.z). The git tag may
        # look like "v1.0.0-beta": strip a leading "v" and drop any "-suffix"
        # (e.g. -beta, -rc) so the resource compiler gets a valid version.
        CLEAN_VERSION = $$GIT_VERSION
        CLEAN_VERSION ~= s/^v//
        TOKENS = $$split(CLEAN_VERSION, -)
        VERSION = $$first(TOKENS)
    } else: VERSION = 0.0.0
}

macx: ICON = assets/icons/$${NAME}.icns
else:win32: RC_ICONS = assets/icons/$${NAME}.ico

INCLUDEPATH += \
    $$PWD/../dfu \
    $$PWD/../backend

DEPENDPATH += \
    $$PWD/../dfu \
    $$PWD/../backend

HEADERS += \
    application.h \
    applicationupdater.h \
    applicationupdateregistry.h \
    qtsingleapplication/qtlocalpeer.h \
    qtsingleapplication/qtlockedfile.h \
    qtsingleapplication/qtsingleapplication.h \
    qtsingleapplication/qtsinglecoreapplication.h \
    screencanvas.h \
    themedimageprovider.h \
    systemfiledialog.h

DISTFILES +=

unix:!macx {
    target.path = $$PREFIX/bin

    desktopfiles.files = $$PWD/../installer-assets/appimage/$${TARGET}.desktop
    desktopfiles.path = $$PREFIX/share/applications

    iconfiles.files = $$PWD/assets/icons/$${TARGET}.png
    iconfiles.path = $$PREFIX/share/icons/hicolor/512x512/apps

    udevfiles.files = $$PWD/../installer-assets/udev/42-flipperzero.rules
    udevfiles.path = $$PREFIX/lib/udev/rules.d

    INSTALLS += target desktopfiles iconfiles udevfiles

} else:win32 {
    target.path = $$DESTDIR/$$NAME
    INSTALLS += target
}
