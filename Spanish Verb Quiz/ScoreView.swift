//
//  ScoreView.swift
//  Spanish Verb Quiz
//
//  Created by sami dannoune on 15.08.25.
//

import SwiftUI

struct ScoreView: View {
    let answerResults: [Bool?]
    
    var body: some View {
            VStack(spacing: 8) {
                if answerResults.count <= 10 {
                    // Single centered HStack for 5 or 10 questions
                    HStack(spacing: 8) {
                        Spacer()
                        ForEach(0..<answerResults.count, id: \.self) { index in
                            Rectangle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(answerResults[index] == nil ? .white : (answerResults[index]! ? .green : .red))
                                .border(Color.gray, width: 1)
                        }
                        Spacer()
                    }
                } else {
                    // Two centered HStacks for 20 questions
                    VStack(spacing: 8) {
                        // First row (indices 0-9)
                        HStack(spacing: 8) {
                            Spacer()
                            ForEach(0..<10, id: \.self) { index in
                                Rectangle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(answerResults[index] == nil ? .white : (answerResults[index]! ? .green : .red))
                                    .border(Color.gray, width: 1)
                            }
                            Spacer()
                        }
                        // Second row (indices 10-19)
                        HStack(spacing: 8) {
                            Spacer()
                            ForEach(10..<answerResults.count, id: \.self) { index in
                                Rectangle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(answerResults[index] == nil ? .white : (answerResults[index]! ? .green : .red))
                                    .border(Color.gray, width: 1)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .padding()
        }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScoreView(answerResults: [true, false, nil, nil, nil]) // 5 questions, centered
            ScoreView(answerResults: [true, false, nil, true, false, nil, nil, nil, nil, nil]) // 10 questions, centered
            ScoreView(answerResults: Array(repeating: nil, count: 20)) // 20 questions, two rows
        }
    }
}
