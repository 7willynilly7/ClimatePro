//
//  VideoPlayerViewController.swift
//  ClimatePro
//
//  Created by Will on 2026-03-28.
//
// This is connected to VideoLesson.swift and allows the file to be played
// and is also used for debugging purposes.

import UIKit
import AVKit
import AVFoundation

final class VideoPlayerViewController: UIViewController {

    private let videoURL: URL
    private let lessonTitle: String
    private var playerViewController: AVPlayerViewController?

    init(videoURL: URL, lessonTitle: String) {
        self.videoURL = videoURL
        self.lessonTitle = lessonTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = lessonTitle
        view.backgroundColor = .systemBackground
        configurePlayer()
    }

    private func configurePlayer() {
        let player = AVPlayer(url: videoURL)
        let playerVC = AVPlayerViewController()
        playerVC.player = player

        addChild(playerVC)
        playerVC.view.frame = view.bounds
        playerVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(playerVC.view)
        playerVC.didMove(toParent: self)

        self.playerViewController = playerVC
        player.play()
    }
}
