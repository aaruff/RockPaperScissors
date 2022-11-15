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
    private var outcome: Outcome
    
}

class RockPaperScissorsGame: ObservableObject {
    private let totalRounds: Int
    
    @Published public var round: Int = 1
    private var computerMoves: [Move] = []
    private var requiredOutcomes: [Outcome] = []
    
    public var computerMove: Move {
        return computerMoves[round]
    }
    public var requiredOutcome: Outcome {
        return requiredOutcomes[round]
    }
    
    
    private var playerMoves: [Move] = []
    private var playerOutcomes: [Outcome] = []
    
    
    init(totalRounds: Int) {
        self.totalRounds = totalRounds
        for _ in 0..<self.totalRounds {
            computerMoves.append(Move.allCases.randomElement() ?? Move.scissors)
            requiredOutcomes.append(Outcome.allCases.randomElement() ?? Outcome.lose)
        }
    }
    
    func nextRound() -> Bool {
        if (round < totalRounds) {
            round += 1
            return true
        }
        else {
            return false
        }
    }
    
    func playRound() {
        assert(playerOutcomes.count < round, "Player outcome has been added more than once for round \(round).")
        
        // The same move results in a tie
        if playerMoves[round] == computerMoves[round] {
            playerOutcomes.append(Outcome.draw)
        }
        // Rock blunts scissors
        else if playerMoves[round] == Move.rock && computerMoves[round] == Move.scissors {
            playerOutcomes.append(Outcome.win)
        }
        // Rock is wrapped by paper
        else if playerMoves[round] == Move.rock && computerMoves[round] == Move.paper {
            playerOutcomes.append(Outcome.lose)
        }
        // Paper wraps rock
        else if playerMoves[round] == Move.paper && computerMoves[round] == Move.rock {
            playerOutcomes.append(Outcome.win)
        }
        // Paper is cut by scissors
        else if playerMoves[round] == Move.paper && computerMoves[round] == Move.scissors {
            playerOutcomes.append(Outcome.lose)
        }
        // Scissors is blunted by rock
        else if playerMoves[round] == Move.scissors && computerMoves[round] == Move.rock {
            playerOutcomes.append(Outcome.lose)
        }
        // Scisors cuts paper
        else {
            playerOutcomes.append(Outcome.win)
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
    @ObservedObject var game = RockPaperScissorsGame(totalRounds: 3)
    
    var body: some View {
        VStack {
            Text("If the computer chooses **\(game.computerMove.rawValue)**")
            Text("What do you play to **\(game.requiredOutcome.rawValue)** the game?")
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
