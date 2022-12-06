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

struct GameDataRectangle: View {
    var title: String
    var value: Int
    var color: Color
    
    var body: some View {
        VStack{
            Text(title)
                .foregroundColor(.white)
            Text("\(value)")
                .foregroundColor(.white)
                .fontWeight(.bold)
            
        }
        .padding()
        .background(color)
        .cornerRadius(20)
        
    }
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
    
    private var roundIndex: Int {
        return _round - 1
    }
    
    public var score: Int {
      get {return _score}
    }
    
    public var round: Int {
        get {return _round}
    }
    
    public var outcome: Bool {
        get {return quizOutcomes[roundIndex]}
    }
    
    public var computerMove: Move {
        return computerMoves[roundIndex]
    }
    
    public var requiredOutcome: GameOutcome {
        return requiredOutcomes[roundIndex]
    }
    
    init(totalRounds: Int) {
        self._totalRounds = totalRounds
        for _ in 0..<self._totalRounds {
            computerMoves.append(Move.allCases.randomElement() ?? Move.scissors)
            requiredOutcomes.append(GameOutcome.allCases.randomElement() ?? GameOutcome.lose)
        }
    }
    
    public func nextRound() {
        if (!isLastRound()) {
            _round += 1
        }
    }
    
    public func isLastRound() -> Bool {
        return _round == _totalRounds
    }
    
    public func newGame() {
        computerMoves = []
        requiredOutcomes = []
        playerMoves = []
        playerOutcomes = []
        quizOutcomes = []
        
        _score = 0
        _round = 1
        
        for _ in 0..<self._totalRounds {
            computerMoves.append(Move.allCases.randomElement() ?? Move.scissors)
            requiredOutcomes.append(GameOutcome.allCases.randomElement() ?? GameOutcome.lose)
        }
    }
    
    public func playRound(playerMove: Move) {
        assert(roundIndex == playerOutcomes.count)
        assert(roundIndex == playerMoves.count)
        
        playerMoves.append(playerMove)
        
        // The same move results in a tie
        if playerMoves[roundIndex] == computerMoves[roundIndex] {
            playerOutcomes.append(GameOutcome.draw)
        }
        // Rock blunts scissors
        else if playerMoves[roundIndex] == Move.rock && computerMoves[roundIndex] == Move.scissors {
            playerOutcomes.append(GameOutcome.win)
        }
        // Rock is wrapped by paper
        else if playerMoves[roundIndex] == Move.rock && computerMoves[roundIndex] == Move.paper {
            playerOutcomes.append(GameOutcome.lose)
        }
        // Paper wraps rock
        else if playerMoves[roundIndex] == Move.paper && computerMoves[roundIndex] == Move.rock {
            playerOutcomes.append(GameOutcome.win)
        }
        // Paper is cut by scissors
        else if playerMoves[roundIndex] == Move.paper && computerMoves[roundIndex] == Move.scissors {
            playerOutcomes.append(GameOutcome.lose)
        }
        // Scissors is blunted by rock
        else if playerMoves[roundIndex] == Move.scissors && computerMoves[roundIndex] == Move.rock {
            playerOutcomes.append(GameOutcome.lose)
        }
        // Scisors cuts paper
        else {
            playerOutcomes.append(GameOutcome.win)
        }
        
        quizOutcomes.append(playerOutcomes[roundIndex] == requiredOutcomes[roundIndex])
        if (quizOutcomes[roundIndex]) {
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
                    action: self.action,
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
    @State var roundOver = false
    @State var computerMove: String
    @State var requiredOutcome: String
    
    private var game: RockPaperScissorQuiz
    
    init() {
        game = RockPaperScissorQuiz(totalRounds: 3)
        computerMove = game.computerMove.rawValue
        requiredOutcome = game.requiredOutcome.rawValue
    }
    
    var body: some View {
        VStack {
            Text("If the computer chooses **\(computerMove)**")
            Text("What do you play to **\(requiredOutcome)** the game?")
            VStack {
                MoveButton(imageName: "closed-fist", borderWidth: 2, borderColor: Color.gray, action: {
                    game.playRound(playerMove: Move.rock)
                    roundOver = true
                })
                
                MoveButton(imageName: "palm", borderWidth: 2, borderColor: Color.gray, action: {
                    game.playRound(playerMove: Move.paper)
                    roundOver = true
                })
                
                MoveButton(imageName: "victory-2", borderWidth: 2, borderColor: Color.gray, action: {
                    game.playRound(playerMove: Move.scissors)
                    roundOver = true
                })
                HStack {
                    GameDataRectangle(title: "Round", value: game.round, color: .gray)
                    GameDataRectangle(title: "Score", value: game.score, color: .orange)
                }
            }
            .alert(isPresented: $roundOver) {
                Alert(
                    title: Text(game.isLastRound() ? "End of Game" : "End of Round"),
                    message: Text("You made the \(game.outcome ? "correct" : "incorrect") move."),
                    dismissButton: .default(Text("OK")){
                        if (!game.isLastRound()) {
                            game.nextRound()
                            computerMove = game.computerMove.rawValue
                            requiredOutcome = game.requiredOutcome.rawValue
                        }
                        else {
                            game.newGame()
                        }
                    })
            }
        }
        .padding()
    }
    
    func handleButtonTapped() {
        print("test")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
