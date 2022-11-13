//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Anwar Ruff on 11/10/22.
//

import SwiftUI

enum Outcome {
    case win, lose
}

enum Move {
    case rock, paper, scissors
}

struct MoveButton: View {
    var imageName: String
    var borderWidth: CGFloat
    var borderColor: Color
    var action: () -> Void
    
    var body: some View {
                Button(
                    role: .none,
                    action: {},
                    label: {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width:100)
                        
                    }
                )
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(borderColor, lineWidth: borderWidth))
        
    }
}


struct ContentView: View {
    let outcomeStates = ["Win", "Lose"]
    let moves = ["Rock", "Paper", "Scissors"]
    
    @State var choice = Int.random(in: 0..<3)
    @State var outcome = Int.random(in: 0..<2)
    @State var move = 0
    var body: some View {
        VStack {
            Text("If the computer chooses **\(moves[choice])**")
            Text("What do you play to **\(outcomeStates[outcome])** the game?")
            VStack {
                MoveButton(imageName: "closed-fist", borderWidth: 2, borderColor: Color.gray) {
                   if (
                }
                
                MoveButton(imageName: "palm", borderWidth: 2, borderColor: Color.gray){
                    
                }
                
                MoveButton(imageName: "victory-2", borderWidth: 2, borderColor: Color.gray){
                    
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
