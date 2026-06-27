QT -= gui
QT += serialport network

include(../qflipper_common.pri)

TARGET = $${NAME}-cli

DESTDIR = $$OUT_PWD/..
CONFIG += c++11 console
CONFIG -= app_bundle

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
        # Manifest VERSION must be numeric (x.y.z); strip leading "v" and any
        # "-suffix" (e.g. -beta, -rc) from the git tag like "v1.0.0-beta".
        CLEAN_VERSION = $$GIT_VERSION
        CLEAN_VERSION ~= s/^v//
        TOKENS = $$split(CLEAN_VERSION, -)
        VERSION = $$first(TOKENS)
    } else: VERSION = 0.0.0
}

macx: ICON = $$PWD/../application/assets/icons/$${NAME}.icns
else:win32: RC_ICONS = $$PWD/../application/assets/icons/$${NAME}-cli.ico

INCLUDEPATH += \
    $$PWD/../dfu \
    $$PWD/../backend

SOURCES += \
        main.cpp \
        cli.cpp

HEADERS += \
    cli.h

unix:!macx {
    target.path = $$PREFIX/bin
} else:macx {
    target.path = $$DESTDIR/$${NAME}.app/Contents/MacOS
} else:win32 {
    target.path = $$DESTDIR/$$NAME
}

INSTALLS += target
