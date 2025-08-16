//
//  VerbConjugationView.swift
//  Spanish Verb Quiz
//
//  Created by sami dannoune on 16.08.25.
//

import SwiftUI

struct VerbStudyView: View {
    let infinitive: String
    let verbs: [Verb]
    let availableTenses: [String]
    
    private var filterVerbs: [Verb] {
        verbs.filter { $0.infinitive == infinitive }
            .sorted { v1, v2 in
                let tenseOrder1 = availableTenses.firstIndex(of: v1.tense) ?? 0
                let tenseOrder2 = availableTenses.firstIndex(of: v2.tense) ?? 0
                if tenseOrder1 == tenseOrder2 {
                    return v1.pronoun < v2.pronoun
                }
                return tenseOrder1 < tenseOrder2
            }
    }
    
    var body: some View {
        List {
            Section(header: Text(infinitive.capitalized).font(.title2)) {
                ForEach(filterVerbs, id: \.self) { verb in
                    HStack {
                        Text("\(verb.tense.capitalized) (\(verb.pronoun))")
                            .font(.subheadline)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        Text(verb.correctAnswer)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .navigationTitle("Study \(infinitive.capitalized)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Equatable for preview
extension Verb: Equatable {
    static func == (lhs: Verb, rhs: Verb) -> Bool {
        lhs.infinitive == rhs.infinitive &&
        lhs.tense == rhs.tense &&
        lhs.pronoun == rhs.pronoun &&
        lhs.correctAnswer == rhs.correctAnswer
    }
}

struct VerbStudyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VerbStudyView(
                infinitive: "hablar",
                verbs: [
                    Verb(infinitive: "hablar", tense: "presente", pronoun: "yo", correctAnswer: "hablo"),
                    Verb(infinitive: "hablar", tense: "presente", pronoun: "tú", correctAnswer: "hablas"),
                    Verb(infinitive: "hablar", tense: "futuro", pronoun: "yo", correctAnswer: "hablaré")
                ],
                availableTenses: ["presente", "futuro"]
            )
        }
    }
}

