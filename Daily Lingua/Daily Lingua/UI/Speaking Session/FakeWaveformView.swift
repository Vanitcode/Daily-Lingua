//
//  FakeWaveformView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 11/9/25.
//

import SwiftUI

struct FakeWaveformView: View {
    let audioLevels: [CGFloat]

    var body: some View {
        HStack(spacing: 2) {
            ForEach(audioLevels.indices, id: \.self) { i in
                Capsule()
                    .frame(width: 3, height: audioLevels[i])
                    .foregroundColor(.pink)
            }
        }
        .frame(height: 100)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    //FakeWaveformView()
}
