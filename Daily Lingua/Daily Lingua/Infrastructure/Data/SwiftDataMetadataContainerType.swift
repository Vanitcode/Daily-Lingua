//
//  SwiftDataMetadataContainerType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 24/6/25.
//

import Foundation

protocol SwiftDataMetadataContainerType {
    @MainActor func getLastFetchDate(for week: String) async -> Date?
    @MainActor func updateLastFetchDate(for week: String) async
}
