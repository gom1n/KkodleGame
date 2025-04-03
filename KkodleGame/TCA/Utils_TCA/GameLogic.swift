//
//  GameLogic.swift
//  KkodleGame
//
//  Created by 고민채(Minchae Go) on 4/3/25.
//

import UIKit

struct GameLogic {
    static func loadAnswerPool() -> [String] {
        guard let path = Bundle.main.path(forResource: "COMMON_NOUNS", ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
            return []
        }
        return content.components(separatedBy: .newlines).filter { !$0.isEmpty }
    }

    static func loadValidDecomposedList() -> [[String]] {
        guard let path = Bundle.main.path(forResource: "ALL_NOUNS", ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
            return []
        }
        let words = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        return words.map { Jamo.decompose($0).map { String($0) } }
    }

    static func generateAnswer(from pool: [String]) -> (answer: [String], raw: String) {
        while true {
            let rawAnswer = pool.randomElement() ?? ""
            let decomposed = Jamo.decompose(rawAnswer).map { String($0) }
            if decomposed.count == 6 {
                return (decomposed, rawAnswer)
            }
        }
    }

    static func isValidJamoWord(_ input: [String], in decomposedList: [[String]]) -> Bool {
        return decomposedList.contains(where: { $0 == input })
    }

    static func compare(input: [String], to answer: [String]) -> [JamoTile] {
        var result: [JamoTile] = []
        var remaining = answer

        for i in 0..<input.count {
            if input[i] == answer[i] {
                result.append(JamoTile(character: input[i], color: .blue))
                remaining[i] = "✓"
            } else {
                result.append(JamoTile(character: input[i], color: .gray))
            }
        }

        for i in 0..<input.count {
            if result[i].color == .gray, let idx = remaining.firstIndex(of: input[i]) {
                result[i].color = .lightBlue
                remaining[idx] = "✓"
            }
        }

        return result
    }

    static func createShareText(_ attempts: [[JamoTile]]) {
        var result = "🍚꼬들밥🍚 \(attempts.count)회 만에 성공!✨\n\n"

        for attempt in attempts {
            for tile in attempt {
                switch tile.color {
                case .blue: result += "💙"
                case .lightBlue: result += "🩵"
                case .gray: result += "🤍"
                }
            }
            result += "\n"
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy년 M월 d일 (E) a h시 m분"
        let dateString = formatter.string(from: Date())

        result += "\n\(dateString)"
        UIPasteboard.general.string = result
    }
}
