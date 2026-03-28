//
//  VideoLesson.swift
//  ClimatePro
//
//  Created by Will on 2026-03-28.
//
// This is the video player file. This means nothing since GitHub wont allow
// long mp4 files to be uploaded.

import Foundation

struct VideoLesson {
    let id: String
    let title: String
    let fileName: String
    let fileExtension: String

    var localURL: URL? {
        let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension)

        if url == nil {
            print("❌ VIDEO NOT FOUND: \(fileName).\(fileExtension)")

            // DEBUG: show everything in bundle
            if let files = try? FileManager.default.contentsOfDirectory(atPath: Bundle.main.bundlePath) {
                print("📦 Bundle contains:")
                files.forEach { print(" - \($0)") }
            }
        } else {
            print("✅ Found video: \(fileName).\(fileExtension)")
        }

        return url
    }
}
