class RecordingSessionFactory {
    static func create() -> RecordingSessionView {
        let repository = createRepository() // una sola instancia
        
        return RecordingSessionView(
            viewModel: RecordingSessionViewModel(
                startRecordingAnswer: StartRecordingAnswer(repository: repository),
                stopRecordingAnswer: StopRecordingAnswer(repository: repository),
                fetchAudiosRecord: FetchAudiosRecord(repository: repository)
            )
        )
    }
    
    private static func createRepository() -> ArticleAudiosRecordRepositoryType {
        return ArticleAudiosRecordRepository(
            recordManagerDataSource: createAVRecordManagerDataSource(),
            errorMapper: ArticleRecordsDomainMapperError(), cacheAudiosDataSource: createCacheAudioDataSoruce(),
            
        )
    }
    
    private static func createCacheAudioDataSoruce() -> CacheAudiosDataSourceType {
        return StrategyCacheAudios(temporalCache: InMemoryCacheAudiosDataSource.shared, persistentCache: createPersistanceCacheAudiosDataSource())
    }
    
    private static func createPersistanceCacheAudiosDataSource() -> CacheAudiosDataSourceType {
        return SwiftDataCacheArticleAudiosDataSource(container: SwiftDataContainer.shared)
    }
    
    private static func createAVRecordManagerDataSource() -> AVRecordManagerDataSourceType {
        return AVRecordManagerDataSource(recordManager: AVAudioRecorderManager()) //Infrastructure
    }
}
