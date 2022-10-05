//
//  EmojiMemoryGameView.swift
//  Memory Game
//
//  Created by Ada on 9/13/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
        
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            gameBody
            deckBody
        }
        
        HStack {
            shuffleBtn
            Spacer()
            restartBtn
        }

    }
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) {card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        . onTapGesture {
                for card in game.cards {
                    withAnimation(dealAnimation(for: card)) {
                        deal(card)
                    }
                }
        }
    }
    
    var shuffleBtn: some View {
        Button("Shuffle Cards") {
            withAnimation() {
                game.shuffle()
            }
        }
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .aspectRatio(2/3, contentMode: .fit)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstants.color)
        .padding(.horizontal)
    }
    
    var restartBtn: some View {
        Button("New Game") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.purple
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 3
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}


struct CardView: View {
    
    var card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Timer(startAngle: Angle(degrees: -90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Timer(startAngle: Angle(degrees: -90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                    .opacity(DrawingConstants.timerOpacity)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.size))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
        
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.size / DrawingConstants.scale)
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.scale)
    }
    
    private struct DrawingConstants {
        static let scale: CGFloat = 0.85
        static let size: CGFloat = 32
        static let timerOpacity: CGFloat = 0.5
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
    }
}
        
