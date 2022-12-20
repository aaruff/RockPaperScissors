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
    var backgroundColor: Color
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
                            .padding()
                            .background(backgroundColor)
                            .cornerRadius(20)
                    }
                )
    }
}


struct ContentView: View {
    @State var roundOver = false
    @State var gameOver = false
    @State var mainViewOpacity = 1.0
    @State var computerMove: String
    @State var requiredOutcome: String
    
    private var game: RockPaperScissorQuiz
    
    init() {
        game = RockPaperScissorQuiz(totalRounds: 3)
        computerMove = game.computerMove.rawValue
        requiredOutcome = game.requiredOutcome.rawValue
    }
    
    var body: some View {
        Group {
            VStack {
                Text("\(requiredOutcome.capitalized) Against \(computerMove.capitalized)")
                    .font(.largeTitle)
                VStack {
                    MoveButton(imageName: "closed-fist", borderWidth: 2, backgroundColor: game.computerMove == Move.rock ? Color("LightRed") : Color("LightGray"), action: {
                        game.playRound(playerMove: Move.rock)
                        if (!game.isLastRound()) {
                            roundOver = true
                        }
                        else {
                            gameOver = true
                        }
                        withAnimation(.linear(duration: 0.2)) {
                            mainViewOpacity = 0.5
                        }
                    })
                    
                    MoveButton(imageName: "palm", borderWidth: 2, backgroundColor: game.computerMove == Move.paper ? Color("LightRed") : Color("LightGray"), action: {
                        game.playRound(playerMove: Move.paper)
                        if (!game.isLastRound()) {
                            roundOver = true
                        }
                        else {
                            gameOver = true
                        }
                        withAnimation(.linear(duration: 0.2)) {
                            mainViewOpacity = 0.5
                        }
                    })
                    
                    MoveButton(imageName: "victory-2", borderWidth: 2, backgroundColor: game.computerMove == Move.scissors ? Color("LightRed") : Color("LightGray"), action: {
                        game.playRound(playerMove: Move.scissors)
                        if (!game.isLastRound()) {
                            roundOver = true
                        }
                        else {
                            gameOver = true
                        }
                        withAnimation(.linear(duration: 0.2)) {
                            mainViewOpacity = 0.5
                        }
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
                            withAnimation(.easeInOut(duration: 0.5)) {
                                mainViewOpacity = 1.0
                            }
                            
                            if (!game.isLastRound()) {
                                game.nextRound()
                                computerMove = game.computerMove.rawValue
                                requiredOutcome = game.requiredOutcome.rawValue
                            }
                        })
                }
                .sheet(isPresented: $gameOver, onDismiss: {
                    self.gameOver = false
                    self.roundOver = false
                    game.newGame()
                    withAnimation(.easeInOut(duration: 0.5)) {
                        mainViewOpacity = 1.0
                    }
                }) {
                    Text("Final Score")
                    .font(.largeTitle)
                    HStack {
                        GameDataRectangle(title: "Total Rounds", value: game.round, color: .gray)
                        GameDataRectangle(title: "Your Score", value: game.score, color: .orange)
                    }
                }
            }
            .padding()
            .opacity(mainViewOpacity)
            
        }
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
