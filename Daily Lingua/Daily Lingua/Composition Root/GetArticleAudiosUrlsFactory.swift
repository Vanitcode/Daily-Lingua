//
//  GetArticleAudiosUrlsFactory.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

class GetArticleAudiosUrlsFactory: CreatePracticeSheetView {
    
     func create(articleId: String) -> PracticeSheetView {
         return PracticeSheetView(viewModel: createViewModel(articleId: articleId))
    }
    
    private func createViewModel(articleId:String) -> ArticleLocalAudiosPlayerViewModel {
        ArticleLocalAudiosPlayerViewModel(getArticleLocalAudiosByIdType: createGetArticleLocalAudiosByIdUseCase(), audioPlayerManager: createAudioPlayerManagerUseCase(), articleId: articleId)
    }
    
    // MARK: - AudioPlayerManager
    private func createAudioPlayerManagerUseCase() -> AudioPlayerManagerType {
        return AudioPlayerManager(player: createAudioPlayer())
    }
    
    private func createAudioPlayer() -> AudioPlayerType {
        return AVAudioPlayerManager()
    }
    
    // MARK: - GetArticleLocalAudiosByIdUseCase
    private func createGetArticleLocalAudiosByIdUseCase() -> GetArticleLocalAudiosByIdType {
        return GetArticleLocalAudiosById(repository: createRepository())
    }
    
    private func createRepository() -> ArticleLocalAudiosRepositoryType {
        return  ArticleLocalAudiosRepository(fileManagerDataSource: createFileManagerDataSource(), apiDataSource: createAPIDataSourceArticleAudiosUrls(), mapper: ArticleLocalAudiosMapper())
    }
    
    private func createAPIDataSourceArticleAudiosUrls() -> ApiDataSourceArticleAudiosUrlsType {
        let httpClient = URLSessionHTTPClient(urlResolver: URLSessionResolver())
        return APIArticleAudiosUrlsDataSource(httpClient: httpClient)
    }
    private func createFileManagerDataSource() -> FileManagerDataSourceType {
        let httpClient = URLSessionHTTPClient(urlResolver: URLSessionResolver())
        let managerSession = FileManager()
        return FileManagerDataSource(fileManager: SessionFileManagerClient(session: managerSession, httpClient: httpClient))
    }
}
