//
//  APIArticleDataSource.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//

import Foundation

class APIArticleDataSource: ApiDataSourceArticleType {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getArticleByDate(date: String) async -> Result<ArticleDTO, HTTPClientError> {
        var components = URLComponents(string: "https://get-article-by-date-tgm6qoqxqq-uc.a.run.app")!
        components.queryItems = [URLQueryItem(name: "date", value: date)]
        
        guard let url = components.url else {
            return .failure(.badURL)
        }
        
        let result = await httpClient.makeRequest(endpoint: url.absoluteString)
        
        switch result {
        case .success(let data):
            do {
                let article = try JSONDecoder().decode(ArticleDTO.self, from: data)
                return .success(article)
            } catch {
                return .failure(.parsingError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getFreeArticleByWeek(week: String) async -> Result<ArticleDTO, HTTPClientError> {
        var components = URLComponents(string: "https://get-free-article-by-week-tgm6qoqxqq-uc.a.run.app")!
        components.queryItems = [URLQueryItem(name: "weekId", value: week)]
        
        guard let url = components.url else {
            return .failure(.badURL)
        }
        
        let result = await httpClient.makeRequest(endpoint: url.absoluteString)
        
        switch result {
        case .success(let data):
            do {
                let article = try JSONDecoder().decode(ArticleDTO.self, from: data)
                return .success(article)
            } catch {
                return .failure(.parsingError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getArticlesByWeek(week: String) async -> Result<[ArticleDTO], HTTPClientError> {
        var components = URLComponents(string: "https://get-articles-by-week-tgm6qoqxqq-uc.a.run.app")!
        components.queryItems = [URLQueryItem(name: "weekId", value: week)]
        
        guard let url = components.url else {
            return .failure(.badURL)
        }
        
        let result = await httpClient.makeRequest(endpoint: url.absoluteString)
        
        switch result {
        case .success(let data):
            do {
                let articles = try JSONDecoder().decode([ArticleDTO].self, from: data)
                return .success(articles)
            } catch {
                return .failure(.parsingError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
