//
//  BluetoothDevice.swift
//  HardwareDetection
//
//  Created by Maulana Frasha on 25/05/25.
//

import Foundation

struct BluetoothDevice: Identifiable, Equatable {
    let name: String
    let uuid: UUID
    let rssi: Int

    var id: UUID { uuid }
}
