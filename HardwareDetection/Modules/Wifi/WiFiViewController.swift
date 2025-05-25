//
//  WiFiViewController.swift
//  HardwareDetection
//
//  Created by Maulana Frasha on 25/05/25.
//


import CoreLocation
import UIKit
import SystemConfiguration.CaptiveNetwork

class WiFiViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let label: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Wi-Fi detection API is not available in iOS\n\n" +
        "To Get Connected Wi-Fi SSID need Paid Apple Developer Account and Set Access Wi-Fi Information Entitlement"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wi-Fi"
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "info.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(showConnectedWiFiAlert)
        )
        view.backgroundColor = .white

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    func getConnectedSSID() -> String? {
        ///Need paid developer account to set Access Wi-Fi Information Entitlement.
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else { return nil }
        for interface in interfaces {
            if let info = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: AnyObject],
               let ssid = info["SSID"] as? String {
                return ssid
            }
        }
        return interfaces.first
    }

    @objc
    func showConnectedWiFiAlert() {
        let ssid = getConnectedSSID() ?? "\nNo Wi-Fi Connection Detected"

        let alert = UIAlertController(
            title: "Connected Wi-Fi",
            message: "You're connected to: \(ssid)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
