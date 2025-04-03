//
//  GameView_TCA.swift
//  KkodleGame
//
//  Created by 고민채(Minchae Go) on 4/3/25.
//

import SwiftUI
import ComposableArchitecture

private struct HeaderView: View {
    @Binding var showHowToPlay: Bool

    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Text("꼬들밥")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)

                Text("한글 자모 맞추기 게임")
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
    }
}


private struct BoardView: View {
    let attempts: [[JamoTile]]
    let currentInput: [String]

    var body: some View {
        VStack(spacing: 6) {
            ForEach(0..<6, id: \.self) { index in
                HStack(spacing: 4) {
                    if index < attempts.count {
                        ForEach(attempts[index]) { tile in
                            TileView(tile: tile)
                        }
                    } else if index == attempts.count {
                        ForEach(0..<6, id: \.self) { i in
                            let character = currentInput.indices.contains(i) ? currentInput[i] : ""
                            TileView(tile: JamoTile(character: character))
                        }
                    } else {
                        ForEach(0..<6, id: \.self) { _ in
                            TileView(tile: JamoTile(character: ""))
                        }
                    }
                }
            }
        }
    }
}

struct GameView_TCA: View {
    let store: StoreOf<GameFeature>
    
    @State private var showHowToPlay = false

    var body: some View {
        WithViewStore(store, observe: \.self) { viewStore in
            VStack(spacing: 12) {
                HeaderView(showHowToPlay: $showHowToPlay)

                Spacer()

                BoardView(attempts: viewStore.state.attempts, currentInput: viewStore.state.currentInput)

                if let error = viewStore.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.top, 6)
                }

                Spacer()

                KeyboardView_TCA(store: store)

                Spacer()
            }
            .padding()
            .sheet(isPresented: $showHowToPlay) {
                NavigationStack {
                    HowToPlayView()
                }
            }
            .overlay(
                Group {
                    if viewStore.isGameOver {
                        ResultAlertView(store: store)
                    }
                }
            )
            .overlay(
                Group {
                    if viewStore.showCopyToast {
                        ToastView(message: "🍚 복사되었습니다!")
                    }
                }
            )
        }
    }
}

#Preview {
//    GameView(store: GameFeature())
//    GameView(store: Store(initialState: GameFeature.State(), reducer: {
//        GameFeature()
//    }))
}
