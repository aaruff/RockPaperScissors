//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Anwar Ruff on 11/10/22.
//

import SwiftUI

enum GameOutcome: String, CaseIterable {
    case win, lose, draw
}

enum Move: String, CaseIterable {
    case rock, paper, scissors
}


class RockPaperScissorQuiz: ObservableObject {
    private let _totalRounds: Int
    private var _score: Int = 0
    private var _round: Int = 1
    private var computerMoves: [Move] = []
    private var requiredOutcomes: [GameOutcome] = []
    private var playerMoves: [Move] = []
    private var playerOutcomes: [GameOutcome] = []
    private var quizOutcomes: [Bool] = []
    
    public var score: Int {
      get {return _score}
    }
    
    public var round: Int {
        get {return _round}
    }
    
    public var outcome: Bool {
        get {
            return quizOutcomes[_round]
        }
    }
    
    
    public var computerMove: Move {
        return computerMoves[_round]
    }
    
    public var requiredOutcome: GameOutcome {
        return requiredOutcomes[_round]
    }
    
    
    init(totalRounds: Int) {
        self._totalRounds = totalRounds
        for _ in 0..<self._totalRounds {
            computerMoves.append(Move.allCases.randomElement() ?? Move.scissors)
            requiredOutcomes.append(GameOutcome.allCases.randomElement() ?? GameOutcome.lose)
        }
    }
    
    func addPlayerMove(move: Move) {
        playerMoves.append(move)
    }
    
    func nextRound() -> Bool {
        if (_round < _totalRounds) {
            _round += 1
            return true
        }
        else {
            return false
        }
    }
    
    func playRound(playerMove: Move) {
        assert(playerOutcomes.count < _round, "Player outcome has been added more than once for round \(_round).")
        assert(playerMoves.count < _round, "Player move has been added more than once for round \(_round).")
        
        playerMoves.append(playerMove)
        
        // The same move results in a tie
        if playerMoves[_round] == computerMoves[_round] {
            playerOutcomes.append(GameOutcome.draw)
        }
        // Rock blunts scissors
        else if playerMoves[_round] == Move.rock && computerMoves[_round] == Move.scissors {
            playerOutcomes.append(GameOutcome.win)
        }
        // Rock is wrapped by paper
        else if playerMoves[_round] == Move.rock && computerMoves[_round] == Move.paper {
            playerOutcomes.append(GameOutcome.lose)
        }
        // Paper wraps rock
        else if playerMoves[_round] == Move.paper && computerMoves[_round] == Move.rock {
            playerOutcomes.append(GameOutcome.win)
        }
        // Paper is cut by scissors
        else if playerMoves[_round] == Move.paper && computerMoves[_round] == Move.scissors {
            playerOutcomes.append(GameOutcome.lose)
        }
        // Scissors is blunted by rock
        else if playerMoves[_round] == Move.scissors && computerMoves[_round] == Move.rock {
            playerOutcomes.append(GameOutcome.lose)
        }
        // Scisors cuts paper
        else {
            playerOutcomes.append(GameOutcome.win)
        }
        
        quizOutcomes.append(playerOutcomes[_round] == requiredOutcomes[_round])
        if (quizOutcomes[_round]) {
            _score += 1
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
    private var game = RockPaperScissorQuiz(totalRounds: 3)
    @State var roundOver = false
    
    var body: some View {
        VStack {
            Text("If the computer chooses **\(game.computerMove.rawValue)**")
            Text("What do you play to **\(game.requiredOutcome.rawValue)** the game?")
            VStack {
                MoveButton(imageName: "closed-fist", borderWidth: 2, borderColor: Color.gray) {
                    game.playRound(playerMove: Move.rock)
                    roundOver = true
                }
                
                MoveButton(imageName: "palm", borderWidth: 2, borderColor: Color.gray){
                    game.playRound(playerMove: Move.paper)
                    roundOver = true
                }
                
                MoveButton(imageName: "victory-2", borderWidth: 2, borderColor: Color.gray){
                    game.playRound(playerMove: Move.scissors)
                    roundOver = true
                }
            }
            .alert(isPresented: $roundOver) {
                Alert(
                    title: Text("End of Round"),
                    message: Text("You made the \(game.outcome ? "correct" : "incorrect") move.")
                    dismissButton: .default(Text("OK")))
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
