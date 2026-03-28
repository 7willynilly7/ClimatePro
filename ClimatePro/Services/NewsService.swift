//
//  NewsService.swift
//  ClimatePro
//
//  Created by Will on 2026-03-28.
//
// This gets data from a news service using a news API key. You will need to insert
// your own API key in line 27.
// This is a work in progress as it does not filter climate specific news.

import Foundation

final class NewsService {
    
    static let shared = NewsService()
    private init() {}

    struct NewsResponse: Decodable {
        let articles: [NewsArticle]
    }

    func fetchClimateNews(completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
        
        let query = "climate change OR sustainability OR carbon emissions"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "climate"
        
        let apiKey = "YOUR_NEWS_API_KEY_HERE"

        let urlString = "https://newsapi.org/v2/everything?q=\(encodedQuery)&language=en&sortBy=publishedAt&pageSize=20&apiKey=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0)))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(decoded.articles))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
}
