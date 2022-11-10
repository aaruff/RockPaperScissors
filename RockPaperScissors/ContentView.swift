//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Anwar Ruff on 11/10/22.
//

import SwiftUI


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
                Button(
                    role: .none,
                    action: {},
                    label: {
                        Image("fist")
                            .resizable()
                            .scaledToFit()
                            .frame(width:100)
                        
                    }
                    )
                Button(
                    role: .none,
                    action: {},
                    label: {
                        Image("open-hand")
                            .resizable()
                            .scaledToFit()
                            .frame(width:100)
                    }
                    )
                Button(
                    role: .none,
                    action: {},
                    label: {
                        Image("peace")
                            .resizable()
                            .scaledToFit()
                            .frame(width:100)
                    }
                    )
                
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
