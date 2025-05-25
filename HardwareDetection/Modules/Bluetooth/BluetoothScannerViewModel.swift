//
//  BluetoothScannerViewModel.swift
//  HardwareDetection
//
//  Created by Maulana Frasha on 25/05/25.
//


import CoreBluetooth

class BluetoothScannerViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager!
    var bluetoothState: CBManagerState?
    @Published var devices: [BluetoothDevice] = []

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func restartScanning() {
        centralManager.stopScan()
        devices.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
}

extension BluetoothScannerViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bluetoothState = central.state
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.centralManager.stopScan()
                print("Stopped scanning.")
            }
        } else {
            print("Bluetooth not available: \(central.state.rawValue)")
        }
    }

    func centralManager(_ central: CBCentralManager,
                         didDiscover peripheral: CBPeripheral,
                         advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {

        let name = (advertisementData[CBAdvertisementDataLocalNameKey] as? String)
        ?? peripheral.name
        ?? "Unknown Device"

        let device = BluetoothDevice(name: name, uuid: peripheral.identifier, rssi: RSSI.intValue)

        if !devices.contains(where: { $0.uuid == device.uuid }) {
            DispatchQueue.main.async {
                self.devices.append(device)
            }
        }
    }
}
