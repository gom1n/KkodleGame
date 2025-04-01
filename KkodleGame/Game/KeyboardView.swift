//
//  KeyboardView.swift
//  KkodleGame
//
//  Created by gomin on 3/28/25.
//

import Foundation
import SwiftUI

struct KeyboardView: View {
    let rows: [[String]] = [
        ["ㅂ","ㅈ","ㄷ","ㄱ","ㅅ","ㅛ","ㅕ","ㅑ"],
        ["ㅁ","ㄴ","ㅇ","ㄹ","ㅎ","ㅗ","ㅓ","ㅏ","ㅣ"],
        ["ㅋ","ㅌ","ㅊ","ㅍ","ㅠ","ㅜ","ㅡ"]
    ]

    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 6) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: 4) {
                    // 마지막 줄에 지우기 / 확인 버튼 추가
                    if rowIndex == rows.count - 1 {
                        // 지우기 버튼
                        Button(action: {
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            viewModel.removeLast()
                        }) {
                            Image(systemName: "delete.left")
                                .frame(width: 36, height: 44)
                                .background(Color(.systemGray4))
                                .cornerRadius(6)
                        }
                    }

                    ForEach(rows[rowIndex], id: \.self) { jamo in
                        Button(action: {
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            viewModel.addJamo(jamo)
                        }) {
                            Text(jamo)
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 36, height: 44)
                                .background(backgroundColor(for: jamo))
                                .cornerRadius(6)
                                .foregroundColor(.primary)
                        }
                    }

                    if rowIndex == rows.count - 1 {
                        // 확인 버튼
                        Button(action: {
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            viewModel.submit()
                        }) {
                            Image(systemName: "checkmark")
                                .frame(width: 36, height: 44)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
    }

    func backgroundColor(for jamo: String) -> Color {
        switch viewModel.keyboardColors[jamo] {
        case .blue: return .blue.opacity(0.8)
        case .lightBlue: return .cyan.opacity(0.5)
        case .gray: return .gray.opacity(0.4)
        case nil: return .blue.opacity(0.05)
        }
    }
}

#Preview {
    KeyboardView(viewModel: GameViewModel())
}
