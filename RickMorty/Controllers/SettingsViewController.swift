//
//  SettingsViewController.swift
//  RickMorty
//

import UIKit
import StoreKit

final class SettingsViewController: UIViewController {

    // MARK: - Types

    private struct SettingsItem {
        let icon: String
        let iconColor: UIColor
        let title: String
        let action: () -> Void
    }

    // MARK: - Properties

    private var sections: [(title: String, items: [SettingsItem])] = []
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .black)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        buildSections()
        setupHeader()
        setupTableView()
    }

    // MARK: - Build Sections

    private func buildSections() {
        sections = [
            ("General", [
                SettingsItem(icon: "square.and.arrow.up", iconColor: .systemBlue, title: "Share App") { [weak self] in
                    self?.shareApp()
                },
                SettingsItem(icon: "star.fill", iconColor: .systemYellow, title: "Rate Us") { [weak self] in
                    self?.rateApp()
                },
                SettingsItem(icon: "heart.fill", iconColor: .systemPink, title: "Support Us") { [weak self] in
                    self?.supportUs()
                },
            ]),
            ("Information", [
                SettingsItem(icon: "lock.shield.fill", iconColor: .systemGreen, title: "Privacy Policy") { [weak self] in
                    self?.openPrivacyPolicy()
                },
                SettingsItem(icon: "envelope.fill", iconColor: .systemOrange, title: "Contact Us") { [weak self] in
                    self?.contactUs()
                },
                SettingsItem(icon: "info.circle.fill", iconColor: .systemGray, title: "App Version") { [weak self] in
                    self?.showAppVersion()
                },
            ]),
        ]
    }

    // MARK: - Setup

    private func setupHeader() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.backgroundColor = .clear
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - Actions

    private func shareApp() {
        let text = "Check out The Rick and Morty Dimension Guide!"
        let url = URL(string: "https://rickandmortyapi.com")!
        let activityVC = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    private func rateApp() {
        if let scene = view.window?.windowScene {
            AppStore.requestReview(in: scene)
        }
    }

    private func supportUs() {
        let alert = UIAlertController(
            title: "Support Us",
            message: "Thank you for your interest in supporting the app! Sharing with friends is the best way to help.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Share", style: .default) { [weak self] _ in
            self?.shareApp()
        })
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }

    private func openPrivacyPolicy() {
        if let url = URL(string: "https://rickandmortyapi.com/about") {
            UIApplication.shared.open(url)
        }
    }

    private func contactUs() {
        if let url = URL(string: "mailto:support@rickandmorty.app") {
            UIApplication.shared.open(url)
        }
    }

    private func showAppVersion() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

        let alert = UIAlertController(
            title: "App Version",
            message: "Version \(version) (Build \(build))",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        let item = sections[indexPath.section].items[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.image = UIImage(systemName: item.icon)
        config.imageProperties.tintColor = item.iconColor
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].items[indexPath.row].action()
    }
}
