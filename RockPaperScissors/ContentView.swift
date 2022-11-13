//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Anwar Ruff on 11/10/22.
//

import SwiftUI

enum Outcome: String, CaseIterable {
    case win, lose, draw
}

enum Move: String, CaseIterable {
    case rock, paper, scissors
}

struct Player {
    private var move: Move
    
    func playAgainst(otherPlayer: Player) -> Outcome {
        // The same move results in a tie
        if move == otherPlayer.move {
            return Outcome.draw
        }
        // Rock blunts scissors
        else if move == Move.rock && otherPlayer.move == Move.scissors {
            return Outcome.win
        }
        // Rock is wrapped by paper
        else if move == Move.rock && otherPlayer.move == Move.paper {
            return Outcome.lose
        }
        // Paper wraps rock
        else if move == Move.paper && otherPlayer.move == Move.rock {
            return Outcome.win
        }
        // Paper is cut by scissors
        else if move == Move.paper && otherPlayer.move == Move.scissors {
            return Outcome.lose
        }
        // Scissors is blunted by rock
        else if move == Move.scissors && otherPlayer.move == Move.rock {
            return Outcome.lose
        }
        // Scisors cuts paper
        else {
            return Outcome.win
        }
    }
}

struct RockPaperScissorsGame {
    private var players: [Player]
    public var outcomes: [Outcome]
    
    init(players: [Player]) {
        for playerA in players {
            for playerB in players {
                
                if playerA
            }
        }
    }
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
    @State var playerMove: Move = Move.rock
    @State var computerMove = Move.allCases.randomElement() ?? Move.scissors
    @State var gameOutcome = Outcome.allCases.randomElement() ?? Outcome.win
    
    var body: some View {
        VStack {
            Text("If the computer chooses **\(computerMove.rawValue)**")
            Text("What do you play to **\(gameOutcome.rawValue)** the game?")
            VStack {
                MoveButton(imageName: "closed-fist", borderWidth: 2, borderColor: Color.gray) {
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
