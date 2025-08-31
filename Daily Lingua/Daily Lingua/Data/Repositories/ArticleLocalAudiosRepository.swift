//
//  ArticleLocalAudiosRepository.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/7/25.
//

import Foundation

class ArticleLocalAudiosRepository: ArticleLocalAudiosRepositoryType {
    
    private let fileManagerDataSource: FileManagerDataSourceType
    private let apiDataSource: ApiDataSourceArticleAudiosUrlsType
    private let mapper: ArticleLocalAudiosMapper
    
    init(fileManagerDataSource: FileManagerDataSourceType, apiDataSource: ApiDataSourceArticleAudiosUrlsType, mapper: ArticleLocalAudiosMapper) {
        self.fileManagerDataSource = fileManagerDataSource
        self.apiDataSource = apiDataSource
        self.mapper = mapper
    }
    
    func getLocalAudios(for articleId: String) async -> Result<ArticleLocalAudios, ArticleLocalAudiosDomainError> {
        let remoteResult = await apiDataSource.getArticleAudiosUrlsById(articleId: articleId)

        guard case .success(let dto) = remoteResult else {
            return .failure(.remoteError)
        }

        let urls = [
            dto.title_audio_url,
            dto.article_audio_url,
            dto.question1_audio_url,
            dto.question2_audio_url,
            dto.question3_audio_url
        ]

        var localURLMap: [String: URL] = [:]

        for url in urls {
            do {
                let result = try await fileManagerDataSource.getLocalAudios(from: url)
                guard case .success(let localURL) = result else {
                    return .failure(.localError)
                }
                localURLMap[url] = localURL
            } catch {
                return .failure(.localError)
            }
        }

        let localAudios = mapper.map(from: dto, with: localURLMap)
        return .success(localAudios)
        }
}
