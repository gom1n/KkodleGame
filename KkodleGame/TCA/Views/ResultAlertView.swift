//
//  ResultAlertView.swift
//  KkodleGame
//
//  Created by 고민채(Minchae Go) on 4/3/25.
//

import SwiftUI
import ComposableArchitecture

struct ResultAlertView: View {
    let store: StoreOf<GameFeature>

    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            let state = viewStore.state
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 16) {
                    Text(state.alertMessage)
                        .padding(.top, 16)
                        .font(.title2.bold())
                        .foregroundColor(.black)

                    Text("정답은 '\(state.answer)' 입니다!")
                        .font(.headline.bold())
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)

                    Image(state.alertImageName)
                        .resizable()
                        .scaledToFit()
                        .padding()

                    Text(state.alertSubDescription)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 24)

                    if state.showCopyButton {
                        Button("📋 결과 복사하기") {
                            viewStore.send(.copyToClipboard)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    Button("다시 시작") {
                        viewStore.send(.resetGame)
                    }
                    .padding(.bottom, 16)
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, 24)
                .frame(maxWidth: 400)
            }
            .transition(.scale)
        }
    }
}
//
//#Preview {
//    ResultAlertView(store: GameFeature())
//}
