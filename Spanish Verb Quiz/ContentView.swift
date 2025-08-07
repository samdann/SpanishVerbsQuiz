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
    @State private var score: Int = 0
    @State private var verbs: [Verb] = []
    @State private var isLoading: Bool = true
    
    
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
            } else if let question = currentQuestion {
                Text("Spanish Verb Quiz")
                    .font(.largeTitle)
                    .padding()
                
                Text("Conjugate '\(question.infinitive)' in '\(question.tense)' tense for '\(question.pronoun)'")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                
                TextField("Enter conjugation", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .fixedSize()
                    .padding()
                
                Button(action: checkAnswer) {
                    Text("Submit")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Text(feedback)
                    .font(.title3)
                    .foregroundColor(feedback.contains("Correct") ? .green : .red)
                
                Text("Score: \(score)")
                    .font(.title2)
                    .padding()
                
                Spacer()
            } else {
                Text("Error loading verbs")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            loadVerbsAsync()
        }
    }
    
    func checkAnswer() {
        guard var currentQuestion = currentQuestion else { return }
        if userAnswer.lowercased().trimmingCharacters(in: .whitespaces) == currentQuestion.correctAnswer {
            feedback = "Correct!"
            score += 1
        } else {
            feedback = "Incorrect. The answer is '\(currentQuestion.correctAnswer)'."
        }
        
        // Load new question
        if let newQuestion = verbs.randomElement() {
            self.currentQuestion = newQuestion
        } else {
            self.currentQuestion = nil // Fallback if no verbs are available
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
