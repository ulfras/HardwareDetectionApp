//
//  BluetoothViewController.swift
//  HardwareDetection
//
//  Created by Maulana Frasha on 25/05/25.
//

import Combine
import UIKit

class BluetoothScannerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel = BluetoothScannerViewModel()

    private var tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let firstScanView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bluetooth"
        navigationController?.navigationBar.tintColor = .black
        setupTableView()
        setupRefreshControl()
        bindViewModel()
        setupLoadView()
    }

    func setupLoadView() {
        let refreshControl = UIActivityIndicatorView()
        refreshControl.startAnimating()
        refreshControl.style = .large
        refreshControl.color = .gray
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        firstScanView.addSubview(refreshControl)

        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Scan Nearby Devices."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        firstScanView.addSubview(label)

        view.addSubview(firstScanView)
        NSLayoutConstraint.activate([
            refreshControl.centerXAnchor.constraint(equalTo: firstScanView.centerXAnchor),
            refreshControl.centerYAnchor.constraint(equalTo: firstScanView.centerYAnchor, constant: -16),

            label.topAnchor.constraint(equalTo: refreshControl.bottomAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: firstScanView.centerXAnchor),

            firstScanView.topAnchor.constraint(equalTo: view.topAnchor),
            firstScanView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstScanView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstScanView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DeviceListTVCell", bundle: nil), forCellReuseIdentifier: "DeviceListTVCell")
        view.addSubview(tableView)
    }

    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Recheck Nearby Devices")
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func didPullToRefresh() {
        viewModel.restartScanning()
        viewModel.devices.removeAll()
        tableView.reloadData()
    }

    private func bindViewModel() {
        viewModel.$devices
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.firstScanView.isHidden = true
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.devices.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "DeviceListTVCell", for: indexPath
        ) as? DeviceListTVCell else {
            return UITableViewCell()
        }
        let device = viewModel.devices[indexPath.row]
        cell.selectionStyle = .none
        cell.label1.text = "Name: \(device.name)"
        cell.label2.text = "UUID: \(device.uuid)"
        cell.label3.text = "RSSI: \(device.rssi)"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    private var cancellables: Set<AnyCancellable> = []
}
