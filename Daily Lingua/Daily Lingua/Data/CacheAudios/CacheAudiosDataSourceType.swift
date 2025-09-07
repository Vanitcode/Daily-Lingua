//
//  CacheAudiosDataSourceType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 5/9/25.
//

import Foundation

protocol CacheAudiosDataSourceType {
    func getRecords(for articleId: String) async -> ArticleAudiosRecord?
    func saveRecords( _ record: ArticleAudiosRecord, for articleId: String) async
    func deleteRecord(for articleId: String) async
}
