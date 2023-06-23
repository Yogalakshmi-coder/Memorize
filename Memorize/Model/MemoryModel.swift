//
//  MemoryGame.swift
//  Memorize
//
//  Created by Yogalakshmi Balasubramaniam on 3/21/23.
// MODEL

import Foundation

struct MemoryModel<CardContent> where CardContent: Equatable {
    
    private(set) var cards: Array<Card>
    private(set) var Mscore = 0
    private(set) var allMatched = false
    private var count = 0
    
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly }
        set { cards.indices.forEach {cards[$0].isFaceUp = ($0 == newValue)} }
    }
    
    
    mutating func choose(_ card: Card) {
        
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isMatched,
            !cards[chosenIndex].isFaceUp
        {
            if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    
                    Mscore += 1
                    count += 2
                    allMatched = count == cards.count ? true : false
                }
                cards[chosenIndex].isFaceUp = true
               
            } else {
                indexOfOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int,createCardContent: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content,id: pairIndex * 2))
            cards.append(Card(content: content,id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }

    struct Card: Identifiable {           // card declared in Memory game & not poker or any other game card, that's why declared inside the MemoryModel
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        let id: Int
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1{
            return first
        }
        else {
            return nil
        }
    }
}
