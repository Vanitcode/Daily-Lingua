//
//  PracticeSheetFactory.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 15/9/25.
//

import Foundation

class PracticeSheetFactory: CreatePracticeSheetView {
    func create(article: Article) -> PracticeSheetView {
        return PracticeSheetView(viewModel: createViewModel(article: article))
    }
    
    private func createViewModel(article: Article) -> PracticeSheetViewModel {
        let repositoryRecords = createAudiosRecordRepository()
        
        return PracticeSheetViewModel(getArticleLocalAudiosById: createGetArticleLocalAudiosByIdUseCase(), audioPlayerManager: createAudioPlayerManagerUseCase(), startRecordingAnswer: createStartRecordingAnswer(repository: repositoryRecords), stopRecordingAnswer: createStopRecordingAnswer(repository: repositoryRecords), fetchAudiosRecord: createFetchAudiosRecord(repository: repositoryRecords), article: article)
    }
    
    // MARK: - GetArticleLocalAudiosByIdUseCase
    private func createGetArticleLocalAudiosByIdUseCase() -> GetArticleLocalAudiosByIdType {
        return GetArticleLocalAudiosById(repository: createLocalAudiosRepository())
    }
    // MARK: - AudioPlayerManager
    private func createAudioPlayerManagerUseCase() -> AudioPlayerManagerType {
        return AudioPlayerManager(player: createAudioPlayer())
    }
    
    private func createAudioPlayer() -> AudioPlayerType {
        return AVAudioPlayerManager()
    }
    
    // MARK: - Repository and DataSources for ArticleAudios
    private func createLocalAudiosRepository() -> ArticleLocalAudiosRepositoryType {
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
    
    // MARK: - Repository and DataSources for ArticleRecords
    private func createAudiosRecordRepository() -> ArticleAudiosRecordRepositoryType {
        return ArticleAudiosRecordRepository(
            recordManagerDataSource: createAVRecordManagerDataSource(),
            errorMapper: ArticleRecordsDomainMapperError(),
            cacheAudiosDataSource: createCacheAudioDataSoruce(),
            
        )
    }
    
    private func createCacheAudioDataSoruce() -> CacheAudiosDataSourceType {
        return StrategyCacheAudios(temporalCache: InMemoryCacheAudiosDataSource.shared, persistentCache: createPersistanceCacheAudiosDataSource())
    }
    
    private func createPersistanceCacheAudiosDataSource() -> CacheAudiosDataSourceType {
        return SwiftDataCacheArticleAudiosDataSource(container: SwiftDataContainer.shared)
    }
    
    private func createAVRecordManagerDataSource() -> AVRecordManagerDataSourceType {
        return AVRecordManagerDataSource(recordManager: AVAudioRecorderManager())
    }
    
    //MARK: - Uses Cases for recording
    private func createStartRecordingAnswer(repository: ArticleAudiosRecordRepositoryType) -> StartRecordingAnswerType {
        return StartRecordingAnswer(repository: repository)
    }
    private func createStopRecordingAnswer(repository: ArticleAudiosRecordRepositoryType) -> StopRecordingAnswerType {
        return StopRecordingAnswer(repository: repository)
    }
    private func createFetchAudiosRecord(repository: ArticleAudiosRecordRepositoryType) -> FetchAudiosRecordType {
        return FetchAudiosRecord(repository: repository)
    }
}
