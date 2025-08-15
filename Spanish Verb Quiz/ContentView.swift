//
//  ContentView.swift
//  Spanish Verb Quiz
//
//  Created by sami dannoune on 07.08.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = QuizViewModel()
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            if viewModel.isLoading {
                ProgressView("Loading verbs...")
                    .progressViewStyle(.circular)
                    .padding()
            } else if viewModel.selectedTense == nil {
                TenseSelectionView(
                    availableTenses: viewModel.availableTenses,
                    onTenseSelected: { tense in
                        viewModel.selectTense(tense)
                    }
                )
            } else if viewModel.selectedQuestionCount == nil {
                QuestionCountView(
                    availableQuestionCounts: viewModel.availableQuestionCounts,
                    onQuestionCountSelected: { count in
                        viewModel.selectQuestionCount(count)
                    },
                    onChangeTense: {
                        viewModel.resetQuiz()
                    }
                )
            } else if let question = viewModel.currentQuestion, viewModel.questionsAnswered < viewModel.selectedQuestionCount! {
                QuizView(
                    question: question,
                    userAnswer: $viewModel.userAnswer,
                    feedback: $viewModel.feedback,
                    selectedTense: viewModel.selectedTense!,
                    correctAnswers: viewModel.correctAnswers,
                    incorrectAnswers: viewModel.incorrectAnswers,
                    selectedQuestionCount: viewModel.selectedQuestionCount!,
                    answerResults: viewModel.answerResults,
                    onSubmit: {
                        viewModel.checkAnswer()
                    },
                    onChangeTenseOrQuestions: {
                        viewModel.resetQuiz()
                    }
                )
            } else {
                QuizCompletionView(
                    correctAnswers: viewModel.correctAnswers,
                    incorrectAnswers: viewModel.incorrectAnswers,
                    selectedQuestionCount: viewModel.selectedQuestionCount!,
                    answerResults: viewModel.answerResults,
                    onStartNewQuiz: {
                        viewModel.resetQuiz()
                    }
                )
            }
        }
        .onAppear {
            viewModel.loadVerbsAsync()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
