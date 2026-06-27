#include "guisendasciioperation.h"

#include "protobufplugininterface.h"

using namespace Flipper;
using namespace Zero;

GuiSendAsciiOperation::GuiSendAsciiOperation(uint32_t id, int value, QObject *parent):
    AbstractProtobufOperation(id, parent),
    m_value(value)
{}

const QString GuiSendAsciiOperation::description() const
{
    return QStringLiteral("Gui Send Ascii");
}

const QByteArray GuiSendAsciiOperation::encodeRequest(ProtobufPluginInterface *encoder)
{
    
    int mapped_key = -1;

    // Map Qt virtual keys and ASCII chars to Flipper keys
    switch(m_value) {
        case 0x01000013: // Qt::Key_Up
        case 'w': case 'W':
            mapped_key = 0; // InputKeyUp
            break;
        case 0x01000015: // Qt::Key_Down
        case 's': case 'S':
            mapped_key = 1; // InputKeyDown
            break;
        case 0x01000014: // Qt::Key_Right
        case 'd': case 'D':
            mapped_key = 2; // InputKeyRight
            break;
        case 0x01000012: // Qt::Key_Left
        case 'a': case 'A':
            mapped_key = 3; // InputKeyLeft
            break;
        case 0x01000004: // Qt::Key_Return
        case 0x01000005: // Qt::Key_Enter
        case ' ':
            mapped_key = 4; // InputKeyOk
            break;
        case 0x01000000: // Qt::Key_Escape
        case 0x01000003: // Qt::Key_Backspace
        case 'q': case 'Q':
            mapped_key = 5; // InputKeyBack
            break;
        default:
            break;
    }

    if(mapped_key != -1) {
        // Encode a standard Release (1) packet using the operation's valid transaction ID
        return encoder->guiSendInput(id(), mapped_key, 1); // 1 = InputTypeRelease
    }

    return QByteArray(); // Discard unmapped keys safely
}