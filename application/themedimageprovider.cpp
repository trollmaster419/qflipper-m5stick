#include "themedimageprovider.h"

#include <QFile>
#include <QPainter>
#include <QSvgRenderer>

ThemedImageProvider::ThemedImageProvider():
    QQuickImageProvider(QQuickImageProvider::Image)
{
    // Purple base hexes (as stored in the SVG assets) -> per-palette equivalents.
    // Roles: L1/L2 light accents, D1/D2 darks, M2 medium, B1..B3 body gradient.
    const QStringList bases = {
        "#7d3fc9", "#6a1bb3", "#1c0636", "#180a28",
        "#2e1257", "#32125e", "#25103f", "#160a2e"
    };

    m_maps["amber"] = {
        {"#7d3fc9", "#ff9722"}, {"#6a1bb3", "#fe8a2c"}, {"#1c0636", "#491d00"}, {"#180a28", "#3a1f10"},
        {"#2e1257", "#76380b"}, {"#32125e", "#3c1a00"}, {"#25103f", "#2a1400"}, {"#160a2e", "#1a0c00"}
    };
    m_maps["green"] = {
        {"#7d3fc9", "#3fc95a"}, {"#6a1bb3", "#1bb33d"}, {"#1c0636", "#06361a"}, {"#180a28", "#0a2814"},
        {"#2e1257", "#125730"}, {"#32125e", "#0a3a1c"}, {"#25103f", "#072a14"}, {"#160a2e", "#04160a"}
    };
    m_maps["blue"] = {
        {"#7d3fc9", "#3f8fc9"}, {"#6a1bb3", "#1b6ab3"}, {"#1c0636", "#061c36"}, {"#180a28", "#0a1828"},
        {"#2e1257", "#122e57"}, {"#32125e", "#0a2440"}, {"#25103f", "#07182e"}, {"#160a2e", "#041020"}
    };
    // "purple" is the identity (source assets are already purple); no map needed.
    Q_UNUSED(bases)
}

QImage ThemedImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    // id = "<palette>/<resourcePath>"
    const int slash = id.indexOf('/');
    const QString palette = slash > 0 ? id.left(slash) : QStringLiteral("purple");
    const QString path = slash > 0 ? id.mid(slash + 1) : id;

    QFile file(QStringLiteral(":/") + path);
    if(!file.open(QIODevice::ReadOnly)) {
        return QImage();
    }

    QString svg = QString::fromUtf8(file.readAll());

    const auto it = m_maps.constFind(palette);
    if(it != m_maps.constEnd()) {
        const QHash<QString, QString> &map = it.value();
        for(auto m = map.cbegin(); m != map.cend(); ++m) {
            svg.replace(m.key(), m.value(), Qt::CaseInsensitive);
        }
    }

    QSvgRenderer renderer(svg.toUtf8());
    if(!renderer.isValid()) {
        return QImage();
    }

    QSize target = requestedSize.isValid() && !requestedSize.isEmpty() ? requestedSize
                                                                       : renderer.defaultSize();
    if(target.isEmpty()) {
        return QImage();
    }

    QImage image(target, QImage::Format_ARGB32_Premultiplied);
    image.fill(Qt::transparent);

    QPainter painter(&image);
    painter.setRenderHint(QPainter::Antialiasing, true);
    renderer.render(&painter);
    painter.end();

    if(size) {
        *size = target;
    }
    return image;
}
