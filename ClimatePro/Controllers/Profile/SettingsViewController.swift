//
//  SettingsViewController.swift
//  ClimatePro
//
//  Created by Will on 2026-03-28.
//
// Settings placeholder page

import UIKit

final class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        title = "Settings"

        let label = UILabel()
        label.text = "Settings coming soon ⚙️"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
