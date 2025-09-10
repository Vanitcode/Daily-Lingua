//
//  SessionArticlePresentationView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 8/9/25.
//

import SwiftUI

struct SessionArticlePresentationView: View {
    var article: Article
    @State private var isExpanded: Bool = false
    var body: some View {
        VStack (alignment: .center){
            Image(systemName: "richtext.page").resizable().frame(width: 64, height: 64)
            Text(article.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            }
    }
}

#Preview {
    let article = Article(id: "123456789", title: "El título de prueba de nuestro artículo", text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", question1: "One?", question2: "Two", question3: "Three")
    SessionArticlePresentationView(article: article)
    
}
