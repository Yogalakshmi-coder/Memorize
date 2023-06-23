//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Yogalakshmi Balasubramaniam on 3/18/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var game = EmojiMemoryViewModel()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)           
        }
    }
}
