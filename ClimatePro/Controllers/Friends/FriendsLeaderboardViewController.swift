//
//  FriendsLeaderboardViewController.swift
//  ClimatePro
//
//  Created by Will on 2026-03-27.
//

// This is a mock page since the app isn't supporting internet accounts
// A future update and package could be added to allow this but an Apple Developer Account
// would be required to make this connect.

import UIKit

// MARK: - Model

struct Friend {
    let name: String
    let username: String
    let imageName: String
    var streak: Int
    var lastOpened: Date
}

// MARK: - View Controller

final class FriendsLeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let logoImageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    private let meCard = UIView()

    private let currentUser = Friend(
        name: "Me",
        username: "@rellim77",
        imageName: "me_profile",
        streak: 7,
        lastOpened: Date()
    )

    private var friends: [Friend] = [
        Friend(name: "Liv", username: "@livthebean", imageName: "p1", streak: 5, lastOpened: Date()),
        Friend(name: "Tim", username: "@tcook123", imageName: "p2", streak: 12, lastOpened: Date()),
        Friend(name: "Kinger", username: "@tadckinger", imageName: "p3", streak: 30, lastOpened: Date())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupBackground()
        setupUI()
        updateStreaks()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // MARK: - UI

    private func setupUI() {

        // LOGO
        logoImageView.image = UIImage(named: "climate_logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.alpha = 0.95
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        // TABLE
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // ME CARD (Highlighted)
        meCard.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.08)
        meCard.layer.cornerRadius = 20
        meCard.layer.shadowColor = UIColor.systemTeal.cgColor
        meCard.layer.shadowOpacity = 0.2
        meCard.layer.shadowOffset = CGSize(width: 0, height: 8)
        meCard.layer.shadowRadius = 14
        meCard.layer.borderWidth = 1.5
        meCard.layer.borderColor = UIColor.systemTeal.withAlphaComponent(0.6).cgColor
        meCard.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(logoImageView)
        view.addSubview(meCard)
        view.addSubview(tableView)

        setupMeCard()

        NSLayoutConstraint.activate([

            // LOGO
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 3.2),

            // ME CARD
            meCard.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -15),
            meCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            meCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // TABLE (extra spacing 🔥)
            tableView.topAnchor.constraint(equalTo: meCard.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupMeCard() {

        let rankLabel = UILabel()
        rankLabel.text = "#4"
        rankLabel.font = .boldSystemFont(ofSize: 16)
        rankLabel.textColor = .systemTeal
        rankLabel.translatesAutoresizingMaskIntoConstraints = false

        let profileImage = UIImageView(image: UIImage(named: currentUser.imageName))
        profileImage.layer.cornerRadius = 25
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = currentUser.name
        nameLabel.font = .boldSystemFont(ofSize: 18)

        let usernameLabel = UILabel()
        usernameLabel.text = currentUser.username
        usernameLabel.textColor = .secondaryLabel
        usernameLabel.font = .systemFont(ofSize: 14)

        let streakLabel = UILabel()
        streakLabel.text = "🔥 \(currentUser.streak)"
        streakLabel.font = .boldSystemFont(ofSize: 16)
        streakLabel.textColor = .systemOrange

        let textStack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        let mainStack = UIStackView(arrangedSubviews: [rankLabel, profileImage, textStack, UIView(), streakLabel])
        mainStack.alignment = .center
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        meCard.addSubview(mainStack)

        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 50),

            rankLabel.widthAnchor.constraint(equalToConstant: 40),

            mainStack.leadingAnchor.constraint(equalTo: meCard.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: meCard.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: meCard.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: meCard.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Background

    private func setupBackground() {
        gradientLayer.colors = [
            UIColor.systemGreen.withAlphaComponent(0.12).cgColor,
            UIColor.systemTeal.withAlphaComponent(0.12).cgColor
        ]
        gradientLayer.locations = [0, 1]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Streak Logic

    private func updateStreaks() {
        let now = Date()

        for i in 0..<friends.count {
            let hours = now.timeIntervalSince(friends[i].lastOpened) / 3600

            if hours >= 48 {
                friends[i].streak = 0
            } else if hours >= 24 {
                friends[i].streak += 1
                friends[i].lastOpened = now
            }
        }
    }

    // MARK: - Table

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let friend = friends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell

        cell.configure(with: friend, rank: indexPath.row + 1)
        return cell
    }
}

// MARK: - Cell

final class FriendCell: UITableViewCell {

    private let container = UIView()
    private let profileImage = UIImageView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let streakLabel = UILabel()
    private let rankLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 20
        container.translatesAutoresizingMaskIntoConstraints = false

        profileImage.layer.cornerRadius = 25
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .boldSystemFont(ofSize: 18)
        usernameLabel.font = .systemFont(ofSize: 14)
        usernameLabel.textColor = .secondaryLabel

        streakLabel.font = .boldSystemFont(ofSize: 16)
        streakLabel.textColor = .systemOrange

        rankLabel.font = .boldSystemFont(ofSize: 16)
        rankLabel.textColor = .systemTeal

        let textStack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        let mainStack = UIStackView(arrangedSubviews: [rankLabel, profileImage, textStack, UIView(), streakLabel])
        mainStack.alignment = .center
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(container)
        container.addSubview(mainStack)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 50),

            rankLabel.widthAnchor.constraint(equalToConstant: 40),

            mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with friend: Friend, rank: Int) {
        profileImage.image = UIImage(named: friend.imageName)
        nameLabel.text = friend.name
        usernameLabel.text = friend.username
        streakLabel.text = "🔥 \(friend.streak)"
        rankLabel.text = "#\(rank)"
    }
}
