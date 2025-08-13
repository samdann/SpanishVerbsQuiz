//
//  ContentView.swift
//  Spanish Verb Quiz
//
//  Created by sami dannoune on 07.08.25.
//

import SwiftUI

struct Verb : Codable {
    let infinitive: String
    let tense: String
    let pronoun: String
    let correctAnswer: String
}

struct ContentView: View {
    
    @State private var currentQuestion: Verb?
    @State private var userAnswer: String = ""
    @State private var feedback: String = ""
    @State private var correctAnswers: Int = 0 // Tracks correct answers
    @State private var incorrectAnswers: Int = 0
    @State private var score: Int = 0
    @State private var verbs: [Verb] = []
    @State private var isLoading: Bool = true
    @State private var selectedTense: String? = nil
    @State private var selectedQuestionCount: Int? = nil
    @State private var questionsAnswered: Int = 0
    @State private var availableTenses: [String] = ["presente", "pretérito perfecto", "pretérito indefinido", "imperfecto", "futuro"]
    @State private var avaialbleQuestionCounts: [Int] = [5, 10, 20]
    
    init() {
        _currentQuestion = State(initialValue: Verb(infinitive: "dejar", tense: "present", pronoun: "yo", correctAnswer: "dejo"))
        
        do {
            let loadedVerbs = try loadVerbsFromFile()
            _verbs = State(initialValue: loadedVerbs)
            if let firstVerb = loadedVerbs.randomElement() {
                _currentQuestion = State(initialValue: firstVerb)
            }
        } catch {
            _verbs = State(initialValue: [])
            print("Error loading verbs: \(error)")
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            if isLoading {
                ProgressView("Loading verbs...")
                    .progressViewStyle(.circular)
                    .padding()
            } else if selectedTense == nil {
                //Prompts the user to select a tense to practice
                Text("Select a Tense to Practice")
                    .font(.title)
                    .padding()
                
                ForEach(availableTenses, id: \.self) { tense in
                    Button(action: {
                        selectedTense = tense
                        if let newQuestion = verbs.filter({ $0.tense == tense}).randomElement() {
                            currentQuestion = newQuestion
                        } else {
                            currentQuestion = nil
                        }
                    }) {
                        Text(tense.capitalized)
                            .font(.title3)
                            .padding()
                        //.frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                Spacer()
            } else if selectedQuestionCount == nil {
                Text("How Many Questions?")
                    .font(.title)
                    .padding()
                
                
                ForEach(avaialbleQuestionCounts, id: \.self){ count in
                    Button(action: {
                        selectedQuestionCount = count
                        if let newQuestion = verbs.filter({$0.tense == selectedTense}).randomElement() {
                            currentQuestion = newQuestion
                        } else {
                            currentQuestion = nil
                        }
                    }) {
                        Text("\(count)")
                            .font(.title2)
                            .padding()
                        //.frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                Button(action: {
                    selectedTense = nil // Back to tense selection
                    questionsAnswered = 0
                    correctAnswers = 0
                    incorrectAnswers = 0
                }) {
                    Text("Change Tense")
                        .font(.subheadline)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
                
                Spacer()
            } else if let question = currentQuestion, questionsAnswered < selectedQuestionCount! {
                Text("Spanish Verb Quiz")
                    .font(.title)
                    .padding()
                
                Text("Conjugate '\(question.infinitive)' in '\(question.tense)' tense for '\(question.pronoun)'")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                TextField("Your answer", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                //.fixedSize()
                    .frame(maxWidth: .infinity)
                    .textContentType(.none)
                    .padding()
                
                Button(action: checkAnswer) {
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
                
                Text("Score: \(correctAnswers)/\(selectedQuestionCount!) correct, \(incorrectAnswers)/\(selectedQuestionCount!) incorrect (\(selectedQuestionCount!) questions)")
                    .font(.title2)
                    .padding()
                
                // Button to change tense
                Button(action: {
                    selectedTense = nil // Return to tense selection screen
                    selectedQuestionCount = nil
                    questionsAnswered = 0
                    correctAnswers = 0
                    incorrectAnswers = 0
                    feedback = ""
                    userAnswer = ""
                }) {
                    Text("Change Tense or Questions")
                        .font(.subheadline)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
                Spacer()
            } else {
                // Quiz complete or no questions available
                Text(questionsAnswered >= selectedQuestionCount! ? "Quiz Complete!" : "No questions available for \(selectedTense?.capitalized ?? "selected tense")")
                    .font(.title2)
                    .foregroundColor(questionsAnswered >= selectedQuestionCount! ? .blue : .red)
                    .padding()
                
                Text("Final Score: \(correctAnswers)/\(selectedQuestionCount!) correct, \(incorrectAnswers)/\(selectedQuestionCount!) incorrect (\(selectedQuestionCount!) questions)")
                    .font(.title2)
                    .padding()
                
                Button(action: {
                    selectedTense = nil
                    selectedQuestionCount = nil
                    questionsAnswered = 0
                    correctAnswers = 0
                    incorrectAnswers = 0
                    feedback = ""
                    userAnswer = ""
                }) {
                    Text("Start New Quiz")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
        }
        .padding()
        .onAppear {
            loadVerbsAsync()
        }
    }
    
    func checkAnswer() {
        guard var currentQuestion = currentQuestion,
        let selectedTense = selectedTense,
        let selectedQuestionCount = selectedQuestionCount  else { return }
        print("Checking answer for verb: \(currentQuestion.infinitive), tense: \(currentQuestion.tense), pronoun: \(currentQuestion.pronoun)")

        if userAnswer.lowercased().trimmingCharacters(in: .whitespaces) == currentQuestion.correctAnswer {
            feedback = "Correct!"
            correctAnswers += 1
        } else {
            feedback = "Incorrect. The answer is '\(currentQuestion.correctAnswer)'."
            incorrectAnswers += 1
        }
        
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
    
    func loadVerbsFromFile() throws -> [Verb] {
        guard let url = Bundle.main.url(forResource: "verbs", withExtension: "json") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "verbs.json file not found"])
        }
        
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let verbs = try decoder.decode([Verb].self, from: data)
        return verbs
    }
    
    func loadVerbsAsync() {
        // Run loading in the background to avoid blocking the UI
        print("Loading verbs...")
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let loadedVerbs = try loadVerbsFromFile()
                print("loaded \(loadedVerbs.count) verbs")
                // Update UI on the main thread
                DispatchQueue.main.async {
                    self.verbs = loadedVerbs
                    self.currentQuestion = loadedVerbs.randomElement()
                    self.isLoading = false
                }
            } catch {
                print("Error loading verbs: \(error)")
                // Update UI on the main thread
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
