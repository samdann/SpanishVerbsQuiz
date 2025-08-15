//
//  QuizCompletionView.swift
//  Spanish Verb Quiz
//
//  Created by sami dannoune on 15.08.25.
//

import SwiftUI

struct QuizCompletionView: View {
    let correctAnswers: Int
    let incorrectAnswers: Int
    let selectedQuestionCount: Int
    let answerResults: [Bool?]
    let onStartNewQuiz: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quiz Complete!")
                .font(.title2)
                .foregroundColor(.blue)
                .padding()
            
            ScoreView(answerResults: answerResults)
            
            Text("Final Score: \(correctAnswers)/\(selectedQuestionCount) correct, \(incorrectAnswers)/\(selectedQuestionCount) incorrect (\(selectedQuestionCount) questions)")
                .font(.title2)
                .padding()
            
            Button(action: onStartNewQuiz) {
                Text("Start New Quiz")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct QuizCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        QuizCompletionView(
            correctAnswers: 3,
            incorrectAnswers: 2,
            selectedQuestionCount: 5,
            answerResults: [true, false, true, false, true],
            onStartNewQuiz: {}
        )
    }
}
