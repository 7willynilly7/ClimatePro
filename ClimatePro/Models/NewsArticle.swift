//
//  NewsArticle.swift
//  ClimatePro
//
//  Created by Will on 2026-03-27.
//
// This shows the news articles from the news API

import Foundation

struct NewsArticle: Decodable {
    let title: String
    let description: String?
    let url: String
    let imageUrl: String?
    let publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case url
        case imageUrl = "urlToImage"
        case publishedAt
    }
}
