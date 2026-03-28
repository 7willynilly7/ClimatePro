//
//  ProfileViewController.swift
//  ClimatePro
//
//  Created by Will on 2026-03-27.
//
// Profile page that shows data from HealthKit. Refer to HealthKitManager.swift

import UIKit
import HealthKit

class ProfileViewController: UIViewController {

    // MARK: - Data Model

    struct Activity {
        let type: String
        let distance: Double
        let icon: String
        let points: Int
    }

    var activities: [Activity] = [
        Activity(type: "Bike Ride", distance: 1.0, icon: "bicycle", points: 3),
        Activity(type: "Walk", distance: 2.0, icon: "figure.walk", points: 3),
        Activity(type: "Run", distance: 0.5, icon: "figure.run", points: 3)
    ]

    // MARK: - Constants

    let carbonPerKm: Double = 0.21

    // MARK: - UI

    let scrollView = UIScrollView()
    let contentStack = UIStackView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        print("VIEW DID LOAD ✅")

        setupNavBar()
        setupLayout()

        loadHealthData()
    }

    // MARK: - HealthKit

    func loadHealthData() {
        print("loadHealthData called")

        HealthKitManager.shared.requestAuthorization { success, error in
            print("Health permission result:", success)

            if let error = error {
                print("❌ Error:", error)
            }

            guard success else {
                print("❌ Permission denied or failed")
                return
            }

            print("✅ Permission granted")

            HealthKitManager.shared.fetchTransportationActivitiesForLast7Days { transportActivities in
                print("📦 Activities fetched:", transportActivities.count)

                self.activities = transportActivities.map {
                    Activity(
                        type: $0.type,
                        distance: $0.distanceKM,
                        icon: $0.icon,
                        points: $0.points
                    )
                }

                DispatchQueue.main.async {
                    self.rebuildUI()
                }
            }
        }
    }

    // MARK: - NAV BAR (FIXED)

    func setupNavBar() {
        navigationItem.hidesBackButton = true

        // Fix weird floating nav UI
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = false

        // Logo
        let logoImage = UIImage(named: "climate_logo")
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 28, height: 28)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: imageView)

        // Gear button
        let gear = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )

        navigationItem.rightBarButtonItem = gear
    }

    @objc func openSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    // MARK: - Calculations

    func totalCarbonSaved() -> Double {
        let totalDistance = activities.reduce(0) { $0 + $1.distance }
        return totalDistance * carbonPerKm
    }

    func totalPoints() -> Int {
        return activities.reduce(0) { $0 + $1.points }
    }

    // MARK: - Layout

    func setupLayout() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        addHeader()
        addCarbonStat()
        addDivider()
        addThisWeekSection()
        addPointsSummary()
    }

    // MARK: - Rebuild UI

    func rebuildUI() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        addHeader()
        addCarbonStat()
        addDivider()
        addThisWeekSection()
        addPointsSummary()
    }

    // MARK: - UI Sections

    func addHeader() {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 15
        container.alignment = .center

        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "me_profile")
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 60),
            profileImage.heightAnchor.constraint(equalToConstant: 60)
        ])

        let label = UILabel()
        label.text = "Hi, Will 👋"
        label.font = .boldSystemFont(ofSize: 22)

        container.addArrangedSubview(profileImage)
        container.addArrangedSubview(label)

        contentStack.addArrangedSubview(container)
    }

    func addCarbonStat() {
        let label = UILabel()
        label.text = "Carbon Saved"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel

        let value = UILabel()
        let carbon = totalCarbonSaved()
        value.text = String(format: "%.2f kg CO₂", carbon)
        value.font = .boldSystemFont(ofSize: 34)
        value.textColor = .systemGreen

        contentStack.addArrangedSubview(label)
        contentStack.addArrangedSubview(value)
    }

    func addDivider() {
        let divider = UIView()
        divider.backgroundColor = .systemGray5
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        contentStack.addArrangedSubview(divider)
    }

    func addThisWeekSection() {
        let title = UILabel()
        title.text = "This Week"
        title.font = .boldSystemFont(ofSize: 20)

        contentStack.addArrangedSubview(title)

        for activity in activities {
            contentStack.addArrangedSubview(createActivityRow(activity))
        }
    }

    func addPointsSummary() {
        let total = UILabel()
        total.text = "Total Points: \(totalPoints())"
        total.font = .boldSystemFont(ofSize: 18)
        total.textColor = .systemGreen

        contentStack.addArrangedSubview(total)
    }

    func createActivityRow(_ activity: Activity) -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 10
        container.alignment = .center
        container.distribution = .equalSpacing

        let leftStack = UIStackView()
        leftStack.axis = .horizontal
        leftStack.spacing = 10
        leftStack.alignment = .center

        let icon = UIImageView()
        icon.image = UIImage(systemName: activity.icon)

        let label = UILabel()
        label.text = String(format: "%.2f km %@", activity.distance, activity.type)

        label.font = .systemFont(ofSize: 16)

        leftStack.addArrangedSubview(icon)
        leftStack.addArrangedSubview(label)

        let points = UILabel()
        points.text = "+\(activity.points)"
        points.font = .boldSystemFont(ofSize: 16)
        points.textColor = .systemGreen

        container.addArrangedSubview(leftStack)
        container.addArrangedSubview(points)

        return container
    }
}
