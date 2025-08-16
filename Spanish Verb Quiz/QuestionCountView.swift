//
//  QuestionCountView.swift
//  Spanish Verb Quiz
//
//  Created by sami dannoune on 15.08.25.
//
import SwiftUI

struct QuestionCountView: View {
    let availableQuestionCounts: [Int]
    let onQuestionCountSelected: (Int) -> Void
    let onChangeTense: () -> Void
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How Many Questions?")
                .font(.title)
                .padding()
            
            ForEach(availableQuestionCounts, id: \.self) { count in
                Button(action: {
                    onQuestionCountSelected(count)
                }) {
                    Text("\(count) Questions")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            Button(action: onChangeTense) {
                Text("Change Tense")
                    .font(.subheadline)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct QuestionCountView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCountView(availableQuestionCounts: [5, 10, 20], onQuestionCountSelected: { _ in }, onChangeTense: {})
    }
}

