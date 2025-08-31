//
//  SwiftDataMetadataContainer.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 24/6/25.
//

import Foundation
import SwiftData

class SwiftDataMetadataContainer: SwiftDataMetadataContainerType {
    
    //Singleton
    static let shared = SwiftDataMetadataContainer()
    private let container: ModelContainer
    private let context: ModelContext
    
    private init() {
        let schema = Schema([ArticleFetchInfo.self])
        container = try! ModelContainer(for:schema, configurations: [])
        context = ModelContext(container)
    }
    
    func getLastFetchDate(for week: String) async -> Date? {
        let predicate = #Predicate<ArticleFetchInfo> { $0.week == week }
        let descriptor = FetchDescriptor<ArticleFetchInfo>(predicate: predicate)

        guard let lastFetchDate = try? context.fetch(descriptor).first?.lastFetch else {
            await updateLastFetchDate(for: week)
            return nil
        }
        return lastFetchDate
        
    }
    
    func updateLastFetchDate(for week: String) async {
        let descriptor = FetchDescriptor<ArticleFetchInfo>(
            predicate: #Predicate { $0.week == week }
        )
        
        if let existing = try? context.fetch(descriptor).first {
            existing.lastFetch = Date()
        } else {
            let info = ArticleFetchInfo(week: week, lastFetch: Date())
            context.insert(info)
        }
        
        try? context.save()
    }
}
