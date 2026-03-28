//
//  HomeViewController.swift
//  ClimatePro
//
//  Created by Will on 2026-03-27.
//
// Homepage file

import UIKit
import SafariServices

final class HomeViewController: UITableViewController {
    
    private var articles: [NewsArticle] = []
    private let backgroundView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private let logoImageView = UIImageView()
    private var didSetInitialOffset = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Clean nav
        title = ""
        navigationItem.titleView = nil

        setupBackground()
        setupTopLogo()
        tableView.contentInsetAdjustmentBehavior = .never
        view.bringSubviewToFront(logoImageView)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.rowHeight = 120

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        // Push content down to make room for logo
        tableView.contentInset = UIEdgeInsets(top: 260, left: 0, bottom: 20, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset

        configureHeaderView()
        fetchNews()
    }
    
    // MARK: - Top Logo (REAL FIX)
    
    private func setupTopLogo() {
        logoImageView.image = UIImage(named: "climate_logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.alpha = 0.95
        
        let hostView: UIView = navigationController?.view ?? self.view
        hostView.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            // Pin to VERY top of screen (outside scroll)
            logoImageView.topAnchor.constraint(equalTo: hostView.safeAreaLayoutGuide.topAnchor, constant: 0),
            logoImageView.centerXAnchor.constraint(equalTo: hostView.centerXAnchor),
            
            // Bigger size
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 3.2)
        ])
        
        logoImageView.layer.zPosition = 999
    }
    
    // MARK: - Background
    
    private func setupBackground() {
        backgroundView.frame = tableView.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        gradientLayer.colors = [
            UIColor.systemGreen.withAlphaComponent(0.08).cgColor,
            UIColor.systemTeal.withAlphaComponent(0.08).cgColor
        ]
        gradientLayer.locations = [0, 1]
        
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = backgroundView.bounds

        // Ensure content starts BELOW the logo (prevents overlap)
        if !didSetInitialOffset {
            tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: false)
            didSetInitialOffset = true
        }
    }
    
    // MARK: - Header (NO LOGO NOW)
    
    private func configureHeaderView() {

        let containerView = UIView()
        containerView.backgroundColor = .clear

        let headerLabel = UILabel()
        headerLabel.text = "Climate News"
        headerLabel.font = .boldSystemFont(ofSize: 30)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            headerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])

        containerView.layoutIfNeeded()

        let size = containerView.systemLayoutSizeFitting(
            CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        )

        containerView.frame = CGRect(
            x: 0,
            y: 0,
            width: tableView.bounds.width,
            height: size.height
        )

        tableView.tableHeaderView = containerView
    }
    
    // MARK: - Data
    
    private func fetchNews() {
        NewsService.shared.fetchClimateNews { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("News fetch error:", error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Table
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let article = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)

        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        let containerTag = 2000
        let titleTag = 2001
        let descriptionTag = 2002
        let imageTag = 2003

        let containerView: UIView
        if let existing = cell.contentView.viewWithTag(containerTag) {
            containerView = existing
        } else {
            let view = UIView()
            view.tag = containerTag
            view.translatesAutoresizingMaskIntoConstraints = false
            
            view.backgroundColor = .secondarySystemBackground
            view.layer.cornerRadius = 18
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.05
            view.layer.shadowOffset = CGSize(width: 0, height: 4)
            view.layer.shadowRadius = 8
            
            cell.contentView.addSubview(view)

            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                view.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
            ])

            containerView = view
        }

        let titleLabel: UILabel
        if let existing = containerView.viewWithTag(titleTag) as? UILabel {
            titleLabel = existing
        } else {
            let label = UILabel()
            label.tag = titleTag
            label.font = .boldSystemFont(ofSize: 18)
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(label)
            titleLabel = label
        }

        let descriptionLabel: UILabel
        if let existing = containerView.viewWithTag(descriptionTag) as? UILabel {
            descriptionLabel = existing
        } else {
            let label = UILabel()
            label.tag = descriptionTag
            label.font = .systemFont(ofSize: 14)
            label.textColor = .secondaryLabel
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(label)
            descriptionLabel = label
        }

        let thumbnailImageView: UIImageView
        if let existing = containerView.viewWithTag(imageTag) as? UIImageView {
            thumbnailImageView = existing
        } else {
            let imageView = UIImageView()
            imageView.tag = imageTag
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.backgroundColor = .systemGray5
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)
            thumbnailImageView = imageView

            NSLayoutConstraint.activate([
                imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
                imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 80),
                imageView.heightAnchor.constraint(equalToConstant: 80),

                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
                titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -10),

                descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
                descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
            ])
        }

        titleLabel.text = article.title
        descriptionLabel.text = article.description ?? "No description available"
        thumbnailImageView.image = nil

        if let imageUrlString = article.imageUrl,
           let url = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let currentCell = tableView.cellForRow(at: indexPath),
                           let imageView = currentCell.contentView.viewWithTag(containerTag)?
                            .viewWithTag(imageTag) as? UIImageView {
                            imageView.image = image
                        }
                    }
                }
            }.resume()
        }

        return cell
    }

    // MARK: - Tap
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        guard let url = URL(string: article.url) else { return }

        let safari = SFSafariViewController(url: url)
        present(safari, animated: true)
    }
}
