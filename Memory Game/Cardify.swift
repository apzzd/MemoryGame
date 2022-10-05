//
//  Cardify.swift
//  Memory Game
//
//  Created by Ada on 9/28/22.
//

import SwiftUI

struct Cardify: Animatable, ViewModifier {
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue}
    }
    
    var rotation: Double
    
    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        
        ZStack {
            if rotation < 90 {
                    shape
                        .fill()
                        .foregroundColor(.white)
                    shape
                        .strokeBorder(lineWidth: DrawingConstants.borderWidth)
            } else {
                shape
                    .fill()
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
        .padding(2)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 3
        
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
