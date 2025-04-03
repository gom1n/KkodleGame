//
//  KeyboardView_TCA.swift
//  KkodleGame
//
//  Created by 고민채(Minchae Go) on 4/3/25.
//

import SwiftUI
import ComposableArchitecture

struct KeyboardView_TCA: View {
    let store: StoreOf<GameFeature>

    private let consonants: [String] = ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
    private let vowels: [String] = ["ㅏ", "ㅑ", "ㅓ", "ㅕ", "ㅗ", "ㅛ", "ㅜ", "ㅠ", "ㅡ", "ㅣ"]

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                ForEach(consonants, id: \.self) { jamo in
                    KeyButton(jamo: jamo, store: store)
                }
            }
            HStack(spacing: 4) {
                ForEach(vowels, id: \.self) { jamo in
                    KeyButton(jamo: jamo, store: store)
                }
            }
            HStack(spacing: 4) {
                Button(action: {
                    store.send(.removeLast)
                }) {
                    Image(systemName: "delete.left")
                        .font(.title3)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }

                Button(action: {
                    store.send(.submit)
                }) {
                    Text("입력")
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

struct KeyButton: View {
    let jamo: String
    let store: StoreOf<GameFeature>

    var body: some View {
        WithViewStore(store, observe: \.keyboardColors) { viewStore in
            Text(jamo)
                .font(.headline)
                .frame(width: 32, height: 44)
                .background(color(for: viewStore.state[jamo] ?? .gray))
                .foregroundColor(.black)
                .cornerRadius(8)
                .onTapGesture {
                    store.send(.addJamo(jamo))
                }
        }
    }

    private func color(for color: TileColor) -> Color {
        switch color {
        case .gray:
            return .gray.opacity(0.1)
        case .lightBlue:
            return .cyan.opacity(0.5)
        case .blue:
            return .blue.opacity(0.8)
        }
    }
}
