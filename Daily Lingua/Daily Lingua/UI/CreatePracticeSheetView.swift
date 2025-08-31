//
//  CreatePracticeSheetView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

protocol CreatePracticeSheetView {
    func create(articleId: String) -> PracticeSheetView
}
