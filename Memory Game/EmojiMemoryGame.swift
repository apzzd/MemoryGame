//
//  EmojiMemoryGame.swift
//  Memory Game
//
//  Created by Ada on 9/15/22.
//

import SwiftUI




class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis: [String] = [ "👹", "🤡", "🎃", "💀", "🕷️", "👻", "🍬", "👺", "😈", "🍭", "🐈‍⬛", "😱" ]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 10) { pairIndex in
            EmojiMemoryGame.emojis[pairIndex]
        }
    }
    
    @Published private var model =  createMemoryGame()
    
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK: - Intents
    
    func choose(_ card:  Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}



