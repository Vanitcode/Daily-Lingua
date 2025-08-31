//
//  MetadataDataSourceType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 24/6/25.
//

import Foundation

protocol MetadataDataSourceType {
    func getLastFetchDate(for week: String) async -> Date?
    func updateLastFetchDate(for week: String) async
}
