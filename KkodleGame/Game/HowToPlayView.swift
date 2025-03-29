//
//  HowToPlayView.swift
//  KkodleGame
//
//  Created by gomin on 3/29/25.
//

import Foundation
import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📖 어떻게 플레이하나요?")
                    .font(.title2.bold())

                Text("🍚 \"꼬들밥\"은 한글 자모를 조합해 단어를 맞히는 퍼즐 게임이에요!\n자모 6개로 정답을 유추해보세요.")

                VStack(alignment: .leading, spacing: 8) {
                    Label("🟩 초록색은 ‘정확한 자모 + 위치까지 정답!’", systemImage: "checkmark.seal.fill")
                    Label("🟨 노란색은 ‘단어에 포함돼 있지만 자리가 달라요!’", systemImage: "exclamationmark.triangle.fill")
                    Label("⬜️ 흰색은 ‘정답에 없는 자모예요!’", systemImage: "xmark.circle")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 12) {
                    Text("예시: 정답이 \"오누이\"일 때")
                        .font(.headline)
                    Text("입력 →  ㅁ  ㅣ  ㄴ  ㅏ  ㄹ  ㅣ")
                    Text("결과 → ⬜️🟨🟩⬜️⬜️🟩")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                Text("기회는 총 6번!\n실제 존재하는 단어만 정답으로 등장해요.\n오늘의 꼬들밥을 맛있게 맞혀보세요 😋")
            }
            .padding()
        }
        .navigationTitle("HOW?")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("닫기") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HowToPlayView()
    }
}
