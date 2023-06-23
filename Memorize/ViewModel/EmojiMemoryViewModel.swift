//
//  EmojiMemoryViewModel.swift
//  Memorize
//
//  Created by Yogalakshmi Balasubramaniam on 3/21/23.
//

import SwiftUI

class EmojiMemoryViewModel: ObservableObject {
    typealias Card = MemoryModel<String>.Card
    
    private static let emojis = ["🍐","🍎","🍊","🍌","🍉","🍇","🍓","🫐","🍑","🥝","🍍","🥑","🍏","🍈","🥕","🥦",
                         "🥥","🌶️","🍅","🥒","🍆","🥬","🫒","🌽","🧄","🥔","🍠"]
    
    private static func createMemoryModel() -> MemoryModel<String> {
        MemoryModel(numberOfPairsOfCards: 10){ pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published  private var model = createMemoryModel()
        
    var cards: Array<Card> {
        return model.cards
    }
    
    var score: Int { return model.Mscore}
    var allMatched: Bool { return model.allMatched}
    
    // MARK:  - Intent(S)
    func choose(_ card: MemoryModel<String>.Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    func newGame() {
        model = EmojiMemoryViewModel.createMemoryModel()
    }
}


