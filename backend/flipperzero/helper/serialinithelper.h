#pragma once

#include "abstractoperationhelper.h"

#include <QSerialPortInfo>

class QTimer;

namespace Flipper {
namespace Zero {

class SerialInitHelper : public AbstractOperationHelper
{
    Q_OBJECT

    enum State {
        OpeningPort = AbstractOperationHelper::User,
        SkippingMOTD,
        StartingRPCSession
    };

public:
    SerialInitHelper(const QSerialPortInfo &portInfo, QObject *parent = nullptr);
    QSerialPort *serialPort() const;

private:
    void nextStateLogic() override;

    void openPort();
    void skipMOTD();
    void startRPCSession();

    QSerialPort *m_serialPort;
    QTimer *m_retryTimer;
    int m_retryCount;
    // M5StickC Plus2 ESP32 port presents a direct UART<->RPC bridge with no CLI:
    // skip the MOTD-skip and start_rpc_session handshake and the DTR reset poke.
    bool m_directRpc;
};

}
}

