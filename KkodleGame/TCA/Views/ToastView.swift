//
//  ToastView.swift
//  KkodleGame
//
//  Created by 고민채(Minchae Go) on 4/3/25.
//

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .font(.subheadline)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.bottom, 40)
                .transition(.opacity)
        }
        .animation(.easeInOut(duration: 0.3), value: message)
    }
}
