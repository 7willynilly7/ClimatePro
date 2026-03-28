//
//  VideoLearningViewController.swift
//  ClimatePro
//
//  Created by Will on 2026-03-28.
//
// This is to format everything on the Learn page

import UIKit
import AVFoundation

final class VideoLearningViewController: UITableViewController {

    private let carbonLessons: [VideoLesson] = [
        VideoLesson(id: "lesson1", title: "Reducing Your Daily Carbon Footprint", fileName: "lesson1", fileExtension: "mp4"),
        VideoLesson(id: "lesson2", title: "Simple Sustainable Habits", fileName: "lesson2", fileExtension: "mp4")
    ]

    private let educationLessons: [VideoLesson] = [
        VideoLesson(id: "lesson3", title: "Choosing Greener Transportation", fileName: "lesson3", fileExtension: "mp4"),
        VideoLesson(id: "lesson4", title: "Waste Reduction Basics", fileName: "lesson4", fileExtension: "mp4"),
        VideoLesson(id: "lesson5", title: "Climate Basics Explained", fileName: "lesson5", fileExtension: "mp4"),
        VideoLesson(id: "lesson6", title: "How Recycling Works", fileName: "lesson6", fileExtension: "mp4")
    ]

    private var gradientLayer: CAGradientLayer?
    private let logoImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = ""
        navigationItem.titleView = nil

        setupBackground()
        setupTopLogo()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "VideoLessonCell")
        tableView.rowHeight = 100

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        // Spacer so headers can stick properly
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 240))
        spacer.backgroundColor = .clear
        tableView.tableHeaderView = spacer
    }

    // MARK: - Background

    private func setupBackground() {
        let backgroundView = UIView()

        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemGreen.withAlphaComponent(0.08).cgColor,
            UIColor.systemTeal.withAlphaComponent(0.08).cgColor
        ]
        gradient.locations = [0, 1]

        backgroundView.layer.insertSublayer(gradient, at: 0)
        tableView.backgroundView = backgroundView

        gradientLayer = gradient
    }

    // MARK: - Fixed Logo (same as Home)

    private func setupTopLogo() {
        logoImageView.image = UIImage(named: "climate_logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.alpha = 0.95

        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // SAME SIZE AS HOME
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 3.2)
        ])

        logoImageView.layer.zPosition = 999
        logoImageView.isUserInteractionEnabled = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = tableView.bounds
    }

    // MARK: - Sections

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? carbonLessons.count : educationLessons.count
    }

    // MARK: - Headers

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = section == 0 ? "Carbon Footprint" : "10 Minute Education"
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])

        return container
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    // MARK: - Cells

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let lesson = indexPath.section == 0
            ? carbonLessons[indexPath.row]
            : educationLessons[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoLessonCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = lesson.title
        content.secondaryText = "Tap to watch"
        content.textProperties.numberOfLines = 2

        if let url = lesson.localURL {
            generateThumbnail(from: url) { image in
                DispatchQueue.main.async {
                    var updatedContent = content
                    updatedContent.image = image
                    updatedContent.imageProperties.cornerRadius = 8
                    updatedContent.imageProperties.maximumSize = CGSize(width: 80, height: 80)
                    cell.contentConfiguration = updatedContent
                }
            }
        }

        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        cell.backgroundColor = .clear

        return cell
    }

    // MARK: - Thumbnail Generator

    private func generateThumbnail(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: 1, preferredTimescale: 600)

            do {
                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: cgImage)
                completion(image)
            } catch {
                completion(nil)
            }
        }
    }

    // MARK: - Selection

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let lesson = indexPath.section == 0
            ? carbonLessons[indexPath.row]
            : educationLessons[indexPath.row]

        guard let videoURL = lesson.localURL else {
            let alert = UIAlertController(
                title: "Video Missing",
                message: "Make sure \(lesson.fileName).\(lesson.fileExtension) has been added to the project.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let playerViewController = VideoPlayerViewController(videoURL: videoURL, lessonTitle: lesson.title)

        let nav = UINavigationController(rootViewController: playerViewController)
        nav.modalPresentationStyle = .fullScreen

        present(nav, animated: true)
    }
}
