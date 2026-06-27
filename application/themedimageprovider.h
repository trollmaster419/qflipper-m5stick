#pragma once

#include <QHash>
#include <QString>
#include <QQuickImageProvider>

/*
 * Recolors the baked (purple) illustration SVGs at load time so they follow the
 * selected accent palette (Preferences.colorPalette / Theme.palette).
 *
 * URL form: image://themed/<palette>/<resourcePath>
 *   e.g. image://themed/amber/assets/gfx/images/flipper.svg
 *
 * The source files store the "purple" family; for any other palette the known
 * purple base hexes are substituted for that palette's equivalents, then the
 * SVG is rendered. Colors not in the map (black, reds) are left untouched.
 */
class ThemedImageProvider : public QQuickImageProvider
{
public:
    ThemedImageProvider();
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

private:
    // palette name -> (purple base hex -> target hex), all lowercase
    QHash<QString, QHash<QString, QString>> m_maps;
};
