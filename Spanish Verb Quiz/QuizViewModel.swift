//
//  QuizViewModel.swift
//  Spanish Verb Quiz
//
//  Created by sami dannoune on 15.08.25.
//

import Foundation

class QuizViewModel: ObservableObject {
    @Published var currentQuestion: Verb?
    @Published var userAnswer: String = ""
    @Published var feedback: String = ""
    @Published var correctAnswers: Int = 0
    @Published var incorrectAnswers: Int = 0
    @Published var verbs: [Verb] = []
    @Published var isLoading: Bool = true
    @Published var selectedTense: String? = nil
    @Published var selectedQuestionCount: Int? = nil
    @Published var questionsAnswered: Int = 0
    @Published var answerResults: [Bool?] = []
    let availableTenses: [String] = ["presente", "pretérito perfecto", "pretérito indefinido", "imperfecto", "futuro"]
    let availableQuestionCounts: [Int] = [5, 10, 20]
    
    func checkAnswer() {
        guard let currentQuestion = currentQuestion,
              let selectedTense = selectedTense,
              let selectedQuestionCount = selectedQuestionCount  else { return }
        print("Checking answer for verb: \(currentQuestion.infinitive), tense: \(currentQuestion.tense), pronoun: \(currentQuestion.pronoun)")
        let isCorrect = userAnswer.lowercased().trimmingCharacters(in: .whitespaces) == currentQuestion.correctAnswer
        
        
        if isCorrect {
            feedback = "Correct!"
            correctAnswers += 1
        } else {
            feedback = "Incorrect. The answer is '\(currentQuestion.correctAnswer)'."
            incorrectAnswers += 1
        }
        
        answerResults[questionsAnswered] = isCorrect
        questionsAnswered += 1
        
        // Load new question if not at the limit
        if(questionsAnswered < selectedQuestionCount ){
            if let newQuestion = verbs.filter({ $0.tense == selectedTense }).randomElement() {
                self.currentQuestion = newQuestion
                print("New question: conjugate '\(newQuestion.infinitive)' in \(newQuestion.tense) for '\(newQuestion.pronoun)'")
            } else {
                self.currentQuestion = nil // Fallback if no verbs are available
            }
        } else {
            self.currentQuestion = nil
        }
        userAnswer = ""
    }
    
    func selectTense(_ tense: String) {
        selectedTense = tense
        questionsAnswered = 0
        correctAnswers = 0
        incorrectAnswers = 0
        answerResults = []
    }
    
    func selectQuestionCount(_ count: Int) {
        selectedQuestionCount = count
        answerResults = Array(repeating: nil, count: count)
        if let newQuestion = verbs.filter({ $0.tense == selectedTense }).randomElement() {
            currentQuestion = newQuestion
        } else {
            currentQuestion = nil
        }
    }
    
    func resetQuiz() {
        selectedTense = nil
        selectedQuestionCount = nil
        questionsAnswered = 0
        correctAnswers = 0
        incorrectAnswers = 0
        answerResults = []
        feedback = ""
        userAnswer = ""
    }
    
    func loadVerbsAsync() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let loadedVerbs = try self.loadVerbsFromJSON()
                DispatchQueue.main.async {
                    self.verbs = loadedVerbs
                    self.isLoading = false
                }
            } catch {
                print("Error loading verbs: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.currentQuestion = nil
                }
            }
        }
    }
    
    private func loadVerbsFromJSON() throws -> [Verb] {
        guard let url = Bundle.main.url(forResource: "verbs", withExtension: "json") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "verbs.json file not found"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([Verb].self, from: data)
    }
}
