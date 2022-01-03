//
//  AnimatedImageButton.swift
//  Shazayita
//
//  Created by Henry Javier Serrano Echeverria on 3/1/22.
//

import SwiftUI

struct AnimatedImageButton: View {
    
    @Binding var animationAmount: Double
    
    let systemName: String
    var backgroundColor = Color.blue
    var titleColor = Color.yellow
    
    var body: some View {
        Image(systemName: systemName)
            .font(.title)
            .foregroundColor(titleColor)
            .background(backgroundColor)
            .cornerRadius(16)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.red)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        animation,
                        value: animationAmount
                    )
            )
    }
    
    var animation: Animation {
        if animationAmount == 1 {
            return .easeIn(duration: 0.05)
        }
        return .easeIn(duration: 1)
            .repeatForever(autoreverses: false)
    }
    
}
