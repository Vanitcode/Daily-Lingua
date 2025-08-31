//
//  APIArticleAudiosUrlsDataSource.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

class APIArticleAudiosUrlsDataSource: ApiDataSourceArticleAudiosUrlsType {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getArticleAudiosUrlsById(articleId: String) async -> Result<ArticleAudiosUrlsDTO, HTTPClientError> {
        var components = URLComponents(string: "https://get-article-urls-for-id-tgm6qoqxqq-uc.a.run.app")!
        components.queryItems = [URLQueryItem(name: "articleId", value: articleId)]
        
        guard let url = components.url else {
            return .failure(.badURL)
        }
        
        let result = await httpClient.makeRequest(endpoint: url.absoluteString)
        
        switch result {
        case .success(let data):
            do {
                let article = try JSONDecoder().decode(ArticleAudiosUrlsDTO.self, from: data)
                return .success(article)
            } catch {
                return .failure(.parsingError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
