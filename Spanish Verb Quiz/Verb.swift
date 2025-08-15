//
//  Verb.swift
//  Spanish Verb Quiz
//
//  Created by sami dannoune on 15.08.25.
//

import Foundation

struct Verb: Codable {
    let infinitive: String
    let tense: String
    let pronoun: String
    let correctAnswer: String
}
