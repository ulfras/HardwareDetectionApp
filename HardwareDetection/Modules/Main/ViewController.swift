//
//  ViewController.swift
//  HardwareDetection
//
//  Created by Maulana Frasha on 25/05/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wifiButton: UIButton!
    @IBOutlet weak var bluetoothButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        wifiButton.layer.cornerRadius = 8
        wifiButton.layer.borderWidth = 1
        wifiButton.layer.borderColor = UIColor.black.cgColor

        bluetoothButton.layer.cornerRadius = 8
        bluetoothButton.layer.borderWidth = 1
        bluetoothButton.layer.borderColor = UIColor.black.cgColor
    }

    @IBAction func wifiButtonTapped(_ sender: Any) {
        navigationController?.pushViewController(WiFiViewController(), animated: true)
    }


    @IBAction func bluetoothButtonTapped(_ sender: Any) {
        navigationController?.pushViewController(BluetoothScannerViewController(), animated: true)
    }
}

