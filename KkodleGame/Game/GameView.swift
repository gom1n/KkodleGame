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
    @State private var showHowToPlay = false

    // Alert Properties
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showCopyButton = false
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                VStack(spacing: 5) {
                    Text("꼬들밥")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.primary)

                    Text("Korean Word Puzzle Game")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(.systemGray4))
                }

                HStack {
                    Spacer()
                    Button(action: {
                        showHowToPlay = true
                    }) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
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
        .alert(alertTitle, isPresented: $showAlert) {
            if showCopyButton {
                Button("결과 복사하기") {
                    viewModel.copyResultToClipboard()
                    viewModel.resetGame()
                }
            }
            Button("다시 시작") {
                viewModel.resetGame()
            }
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $showHowToPlay) {
            NavigationStack {
                HowToPlayView()
            }
        }
        .onChange(of: viewModel.isGameOver) { newValue in
            if newValue {
                // 결과 내용 구성
                alertTitle = "게임 종료"
                if viewModel.didWin {
                    alertMessage = "🎉 정답이에요!\n정답: '\(viewModel.rawAnswer)'"
                    showCopyButton = true
                } else {
                    alertMessage = "😢 아쉽네요!\n정답: '\(viewModel.rawAnswer)'"
                    showCopyButton = false
                }
                showAlert = true
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
