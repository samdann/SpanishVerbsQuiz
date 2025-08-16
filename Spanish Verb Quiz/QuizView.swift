//
//  QuizView.swift
//  Spanish Verb Quiz
//
//  Created by sami dannoune on 15.08.25.
//
import SwiftUI

struct QuizView: View {
    let question: Verb
    @Binding var userAnswer: String
    @Binding var feedback: String
    let selectedTense: String
    let correctAnswers: Int
    let incorrectAnswers: Int
    let selectedQuestionCount: Int
    let answerResults: [Bool?]
    let availableTenses: [String]
    let verbs: [Verb]
    let onSubmit: () -> Void
    let onChangeTenseOrQuestions: () -> Void
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Spanish Verb Quiz")
                .font(.largeTitle)
                .padding()
            
            (Text("\(selectedQuestionCount)").bold() +  Text(" questions in the ") + Text("\(selectedTense)").bold() + Text(" tense."))
                .modifier(CustomTextStyle())
            
            HStack {
                Text("Conjugate ")
                NavigationLink(destination: VerbStudyView(infinitive: question.infinitive, verbs: verbs, availableTenses: availableTenses)) {
                   Text(question.infinitive)
                       .font(.title2)
                       .foregroundColor(.blue)
                       .underline()
               }
                Text(" for") + Text(" \(question.pronoun)").bold().italic()
            }
             
             
            
            TextField("Your answer", text: $userAnswer)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
                .textContentType(.none)
                .padding()
            
            Button(action: onSubmit) {
                Text("Submit")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text(feedback)
                .font(.title3)
                .foregroundColor(feedback.contains("Correct") ? .green : .red)
            
            ScoreView(answerResults: answerResults)
            
            
            Button(action: onChangeTenseOrQuestions) {
                Text("Change Tense or Questions")
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

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(
            question: Verb(infinitive: "hablar", tense: "presente", pronoun: "yo", correctAnswer: "hablo"),
            userAnswer: .constant(""),
            feedback: .constant(""),
            selectedTense: "presente",
            correctAnswers: 2,
            incorrectAnswers: 1,
            selectedQuestionCount: 5,
            answerResults: [true, false, nil, nil, nil],
            availableTenses: ["presente", "futuro"],
            verbs: [
                Verb(infinitive: "hablar", tense: "presente", pronoun: "yo", correctAnswer: "hablo")
            ],
            onSubmit: {},
            onChangeTenseOrQuestions: {}
        )
    }
}


struct CustomTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
    }
}
