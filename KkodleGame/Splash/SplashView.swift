//
//  SplashView.swift
//  KkodleGame
//
//  Created by gomin on 3/29/25.
//

import Foundation
import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    @State private var offsetY: CGFloat = 20

    var body: some View {
        ZStack {
            if isActive {
                GameView() // 여기에 메인 게임 뷰 넣기
            } else {
                VStack(spacing: 0) {
                    ZStack {
                        Image("kkodle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 320, height: 320)
                            .opacity(opacity)

                        VStack(spacing: 6) {
                            Text("꼬들밥")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.primary)

                            Text("Korean Word Puzzle Game")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(.systemGray2))
                        }
                        .opacity(opacity)
                        .offset(y: 160)
                    }
                    .offset(y: offsetY)
                }
                .padding(.top, -220)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 209/255, green: 209/255, blue: 214/255))
                .onAppear {
                    withAnimation(.easeOut(duration: 1.2)) {
                        self.opacity = 1.0
                        self.offsetY = 0
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
