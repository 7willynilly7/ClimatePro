//
//  GarbageScannerViewController.swift
//  ClimatePro
//
//  Created by Will on 2026-03-27.
//
// The UI and output file for Scan page. Refer to OpenAIService.swift

import UIKit

final class GarbageScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UI Elements

    private let logoImageView = UIImageView()
    private let cardView = UIView()
    private let imageView = UIImageView()
    private let resultLabel = UILabel()
    private let resultImageView = UIImageView()
    private let scanButton = UIButton(type: .system)
    private let gradientLayer = CAGradientLayer()
    private let pulseLayer = CAShapeLayer()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupBackground()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // MARK: - UI Setup

    private func setupUI() {

        // LOGO (UPDATED SIZE + POSITION)
        logoImageView.image = UIImage(named: "climate_logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.alpha = 0.95

        // Card container
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.12
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardView.layer.shadowRadius = 14
        cardView.translatesAutoresizingMaskIntoConstraints = false

        // Image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Result label
        resultLabel.text = "Scan an item"
        resultLabel.font = .boldSystemFont(ofSize: 26)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 1
        resultLabel.alpha = 0
        resultLabel.translatesAutoresizingMaskIntoConstraints = false

        // Result image
        resultImageView.contentMode = .scaleAspectFit
        resultImageView.alpha = 0
        resultImageView.translatesAutoresizingMaskIntoConstraints = false

        // Button
        scanButton.setTitle("Scan Item", for: .normal)
        scanButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        scanButton.backgroundColor = .systemTeal
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.layer.cornerRadius = 16
        scanButton.layer.shadowColor = UIColor.black.cgColor
        scanButton.layer.shadowOpacity = 0.2
        scanButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        scanButton.layer.shadowRadius = 6
        scanButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false

        // Gradient button background
        let buttonGradient = CAGradientLayer()
        buttonGradient.colors = [UIColor.systemTeal.cgColor, UIColor.systemGreen.cgColor]
        buttonGradient.startPoint = CGPoint(x: 0, y: 0.5)
        buttonGradient.endPoint = CGPoint(x: 1, y: 0.5)
        buttonGradient.cornerRadius = 16
        buttonGradient.frame = CGRect(x: 0, y: 0, width: 180, height: 50)
        scanButton.layer.insertSublayer(buttonGradient, at: 0)

        // Add views
        view.addSubview(logoImageView)
        view.addSubview(cardView)
        cardView.addSubview(imageView)
        view.addSubview(resultImageView)
        view.addSubview(resultLabel)
        view.addSubview(scanButton)

        // Pulse animation layer
        pulseLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 180, height: 50)).cgPath
        pulseLayer.fillColor = UIColor.systemTeal.withAlphaComponent(0.2).cgColor
        pulseLayer.position = CGPoint(x: 0, y: 0)
        scanButton.layer.insertSublayer(pulseLayer, below: scanButton.titleLabel?.layer)

        // Layout
        NSLayoutConstraint.activate([

            // 🔥 LOGO (BIG + HIGH like Home)
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 3.2),

            // Card
            cardView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 300),
            cardView.heightAnchor.constraint(equalToConstant: 300),

            imageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),

            // Label
            resultLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 25),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),

            // Bin image
            resultImageView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            resultImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultImageView.widthAnchor.constraint(equalToConstant: 130),
            resultImageView.heightAnchor.constraint(equalToConstant: 130),
            resultImageView.bottomAnchor.constraint(lessThanOrEqualTo: scanButton.topAnchor, constant: -20),

            // Button
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.widthAnchor.constraint(equalToConstant: 180),
            scanButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        startPulseAnimation()
    }

    private func startPulseAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.1
        animation.duration = 1.2
        animation.autoreverses = true
        animation.repeatCount = .infinity
        pulseLayer.add(animation, forKey: "pulse")
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

    // MARK: - Camera

    @objc private func openCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self

        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        picker.modalPresentationStyle = .fullScreen

        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else { return }

        imageView.image = image
        resultLabel.text = "Analyzing..."
        resultLabel.alpha = 1
        resultImageView.alpha = 0

        OpenAIService.shared.classifyWaste(image: image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let classification):
                    self?.handleResult(classification)
                case .failure:
                    self?.resultLabel.text = "Error analyzing"
                }
            }
        }
    }

    // MARK: - Result Handling

    private func handleResult(_ result: String) {
        let lower = result.lowercased()

        var category = "🗑️ Garbage"
        var color: UIColor = .systemGray
        var imageName = "garbage_bin"

        let generator = UINotificationFeedbackGenerator()

        if lower.contains("recycl") {
            category = "♻️ Recycling"
            color = .systemTeal
            imageName = "recycling_bin"
            generator.notificationOccurred(.success)

        } else if lower.contains("compost") {
            category = "🌱 Compost"
            color = .systemGreen
            imageName = "compost_bin"
            generator.notificationOccurred(.success)

        } else {
            generator.notificationOccurred(.warning)
        }

        var confidenceText = ""
        if let range = lower.range(of: #"\d{1,3}%"#, options: .regularExpression) {
            confidenceText = " (\(lower[range]))"
        }

        resultLabel.text = category + confidenceText
        resultLabel.sizeToFit()
        resultLabel.alpha = 1
        resultLabel.isHidden = false
        view.bringSubviewToFront(resultImageView)
        view.bringSubviewToFront(resultLabel)
        resultLabel.textColor = .label
        resultImageView.image = UIImage(named: imageName)

        resultLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        resultImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: {
            self.resultLabel.transform = .identity
            self.resultImageView.alpha = 1
        })

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 0.6,
                       options: [],
                       animations: {
            self.resultImageView.transform = .identity
        })
    }
}
