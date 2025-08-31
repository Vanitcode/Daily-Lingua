//
//  SwiftMetadataDataSource.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 24/6/25.
//

import Foundation

class SwiftMetadataDataSource: MetadataDataSourceType {
    
    private let container: SwiftDataMetadataContainerType
    
    init(container: SwiftDataMetadataContainerType) {
        self.container = container
    }
    
    func getLastFetchDate(for week: String) async -> Date? {
        await container.getLastFetchDate(for: week)
    }
    
    func updateLastFetchDate(for week: String) async {
        await container.updateLastFetchDate(for: week)
    }
    
    
}
