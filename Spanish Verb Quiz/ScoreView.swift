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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(0..<answerResults.count, id: \.self) { index in
                        Rectangle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(answerResults[index] == nil ? .white : (answerResults[index]! ? .green : .red))
                            .border(Color.gray, width: 1)
                    }
                }
            }
            .padding()
        }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(answerResults: [true, false, nil, true, nil])
    }
}
