//
//  TenseSelectionView.swift
//  Spanish Verb Quiz
//
//  Created by sami dannoune on 15.08.25.
//

import SwiftUI

struct TenseSelectionView: View {
    let availableTenses: [String]
        let onTenseSelected: (String) -> Void
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Select a Tense to Practice")
                    .font(.largeTitle)
                    .padding()
                
                ForEach(availableTenses, id: \.self) { tense in
                    Button(action: {
                        onTenseSelected(tense)
                    }) {
                        Text(tense.capitalized)
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
        }
}

struct TenseSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TenseSelectionView(availableTenses: ["presente", "pretérito perfecto"], onTenseSelected: { _ in })
    }
}
