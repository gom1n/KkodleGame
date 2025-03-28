//
//  GameView.swift
//  KkodleGame
//
//  Created by gomin on 3/28/25.
//

import Foundation
import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 5) {
                Text("꼬들밥")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)

                Text("Korean Word Puzzle Game")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(.systemGray4))
            }
            
            Spacer()

            VStack(spacing: 6) {
                ForEach(0..<6, id: \.self) { index in
                    HStack(spacing: 4) {
                        if index < viewModel.attempts.count {
                            // 시도 완료된 줄
                            ForEach(viewModel.attempts[index]) { tile in
                                TileView(tile: tile)
                            }
                        } else if index == viewModel.attempts.count {
                            // 현재 입력 중인 줄
                            ForEach(0..<6, id: \.self) { i in
                                let character = viewModel.currentInput.indices.contains(i) ? viewModel.currentInput[i] : ""
                                TileView(tile: JamoTile(character: character))
                            }
                        } else {
                            // 아직 입력하지 않은 빈 줄
                            ForEach(0..<6, id: \.self) { _ in
                                TileView(tile: JamoTile(character: ""))
                            }
                        }
                    }
                }
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.top, 6)
            }

            Spacer()

            KeyboardView(viewModel: viewModel)

            Spacer()
        }
        .padding()
        .onTapGesture {
            viewModel.errorMessage = nil
        }
        .alert("게임 종료", isPresented: $viewModel.isGameOver) {
            Button("다시 시작") {
                viewModel.resetGame()
            }
        } message: {
            if viewModel.didWin {
                Text("🎉 정답이에요!\n정답: '\(viewModel.rawAnswer)'")
            } else {
                Text("😢 아쉽네요!\n정답: '\(viewModel.rawAnswer)'")
            }
        }
    }
}

struct TileView: View {
    let tile: JamoTile

    var body: some View {
        Text(tile.character)
            .font(.title)
            .bold()
            .frame(width: 44, height: 44)
            .background(color(for: tile.color))
            .cornerRadius(8)
            .foregroundColor(.white)
    }

    func color(for tileColor: TileColor) -> Color {
        switch tileColor {
        case .gray: return Color(.systemGray4)
        case .yellow: return .yellow
        case .green: return .green
        }
    }
}


#Preview {
    GameView()
}
