//
//  ContentView.swift
//  Memorize
//
//  Created by Yogalakshmi Balasubramaniam on 3/18/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryViewModel
    
    @State private var dealt = Set<Int>()
    
    @Namespace private var dealingNamespace
    
    private func deal(_ card: EmojiMemoryViewModel.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryViewModel.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryViewModel.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * CardConstants.totalDealDuration / Double(game.cards.count)
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zindex(for card: EmojiMemoryViewModel.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                scoreCard
                gameBody
                HStack() {
                    newGame
                    Spacer()
                    shuffle
                }
            }
            .padding()
            deckBody
        }
    }
    var scoreCard: some View {
        HStack {
            let message = game.allMatched ? "You Won" : " "
            Text(message).font(.title2)
            Spacer()
            Text("Score: \(game.score)")
                .font(.body)
        }
    }
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                   
                    .padding(CardConstants.cardSpace)
                    
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zindex(for: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                        
                    }
            }
        }
        .foregroundColor(CardConstants.color)
         
    }
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zindex(for: card))
            }
            
            .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
            .foregroundColor(CardConstants.color)
           
        }
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
            
        }
    }
    var newGame: some View {
        Button("New Game") {
            withAnimation {
                dealt = []
                game.newGame()
            }
        }
       
    }
    var shuffle: some View {
        Button("shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
       
    }
    
    private struct CardConstants {
        static let cardSpace: Double = 5
        static let color = Color.green
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth: CGFloat = undealtHeight * aspectRatio
    }
    
}
struct CardView: View{
    let card: MemoryModel<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90), clockwise: true)
                        .padding(DrawingConstants.circlePadding)
                        .opacity(DrawingConstants.circleOpacity)
                    Text(card.content)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
                        .font(Font.system(size: DrawingConstants.fontSize))
                        .scaleEffect(scale(thatFits: geometry.size))
      
            }

            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize ) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)

    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width,size.height) * DrawingConstants.fontScale)
        
    }
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.65
        static let fontSize: CGFloat = 32
        static let circlePadding: CGFloat = 5
        static let circleOpacity: CGFloat = 0.5
    }
}

















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryViewModel()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
        
//        EmojiMemoryGameView(game: game)
//            .preferredColorScheme(.dark)
//        EmojiMemoryGameView(game: game)
//            .preferredColorScheme(.light)
    }
}
