// Copyright 2013-present Facebook. All Rights Reserved.

import Foundation
import SwiftSocket

class RobotControll {
    let client: TCPClient

    enum Direction: UInt8 {
        case stop = 0x00

        case north =     0x01      // 0001
        case northEast = 0x06
        case east =      0x03      // 0011
        case southEast = 0x07
        case south =     0x02      // 0010
        case southWest = 0x08
        case west =      0x04      // 0100
        case northWest = 0x05

        func bytes() -> [Byte] {
            return [0xff, 0x00, self.rawValue, 0x00, 0xff]
        }
    }

    init(address: String, port: Int32 = 2001) {
        self.client = TCPClient(address: address, port: port)
    }

    func send(direction: Direction) {
        let _ = self.client.send(data: direction.bytes())
    }
}
