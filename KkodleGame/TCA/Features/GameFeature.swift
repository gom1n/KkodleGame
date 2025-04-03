//
//  GameFeature.swift
//  KkodleGame
//
//  Created by 고민채(Minchae Go) on 4/3/25.
//

import ComposableArchitecture

@Reducer
struct GameFeature {
    
    struct State: Equatable {
        var currentInput: [String] = []
        var attempts: [[JamoTile]] = []
        var isGameOver = false
        var didWin = false
        var errorMessage: String?
        var keyboardColors: [String: TileColor] = [:]
        var answer: [String] = []
        var rawAnswer: String = ""
        var showAlert = false
        var showCopyToast = false
        var alertImageName = ""
        var alertSubDescription = ""
        var alertMessage: String = ""
        var showCopyButton: Bool = true
    }
    
    enum Action: Equatable {
        case onAppear
        case addJamo(String)
        case removeLast
        case submit
        case resetGame
        case copyToClipboard
        case hideAlert
        case hideToast
    }

    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(GameFeature.Action.resetGame)
                }

            case let .addJamo(jamo):
                guard !state.isGameOver, state.currentInput.count < 6 else { return .none }
                state.currentInput.append(jamo)
                state.errorMessage = nil
                return .none

            case .removeLast:
                if !state.currentInput.isEmpty {
                    state.currentInput.removeLast()
                    state.errorMessage = nil
                }
                return .none

            case .submit:
                guard state.currentInput.count == 6 else {
                    state.errorMessage = "자모 6개를 입력해주세요!"
                    return .none
                }

                let decomposedList = GameLogic.loadValidDecomposedList()
                if !GameLogic.isValidJamoWord(state.currentInput, in: decomposedList) {
                    state.errorMessage = "존재하지 않는 단어예요!"
                    state.currentInput = []
                    return .none
                }

                let result = GameLogic.compare(input: state.currentInput, to: state.answer)
                state.attempts.append(result)
                state.currentInput = []

                for tile in result {
                    let existing = state.keyboardColors[tile.character]
                    switch (existing, tile.color) {
                    case (_, .blue): state.keyboardColors[tile.character] = .blue
                    case (.blue, _): break
                    case (_, .lightBlue): state.keyboardColors[tile.character] = .lightBlue
                    case (nil, .gray): state.keyboardColors[tile.character] = .gray
                    default: break
                    }
                }

                if result.allSatisfy({ $0.color == .blue }) {
                    state.isGameOver = true
                    state.didWin = true
                    state.alertImageName = "kkodle-23"
                    state.alertSubDescription = "밥풀을 모은 꼬들이는 행복해요!"
                    state.showAlert = true
                } else if state.attempts.count >= 6 {
                    state.isGameOver = true
                    state.didWin = false
                    state.alertImageName = "empty"
                    state.alertSubDescription = "텅 - 다시 한번 해볼까요?"
                    state.showAlert = true
                }

                return .none

            case .resetGame:
                let answerPool = GameLogic.loadAnswerPool()
                let (answer, raw) = GameLogic.generateAnswer(from: answerPool)
                state.answer = answer
                state.rawAnswer = raw

                state.currentInput = []
                state.attempts = []
                state.keyboardColors = [:]
                state.isGameOver = false
                state.didWin = false
                state.errorMessage = nil
                state.showAlert = false
                return .none

            case .copyToClipboard:
                GameLogic.createShareText(state.attempts)
                state.showCopyToast = true
                return .none

            case .hideAlert:
                state.showAlert = false
                return .none

            case .hideToast:
                state.showCopyToast = false
                return .none
            }
        }
    }
}
