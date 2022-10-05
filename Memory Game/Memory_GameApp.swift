//
//  Memory_GameApp.swift
//  Memory Game
//
//  Created by Ada on 9/13/22.
//

import SwiftUI

@main
struct Memory_GameApp: App {
    
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
