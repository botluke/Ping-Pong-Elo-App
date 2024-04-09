//
//  GameInputView.swift
//  Ping Pong
//
//  Created by Luke Botros on 3/21/24.
//

import Foundation
import SwiftUI


struct ResultsView: View {
    
    @Binding var players: [Player]
    @State private var player1 = Player(name: "Select Player")
    @State private var player2 = Player(name: "Select Player")
    @State private var score1: Int?
    @State private var score2: Int?
    @State private var isAddPlayerViewPresented = false
    
    
    private func setDefaultPlayers() {
        if players.count >= 2 {
            player1 = players[0]
            player2 = players[1]
        }
    }

    
    var body: some View {
        if players.count >= 2 {
            ZStack{
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                VStack{
                    HStack {
                        Spacer()
                        VStack {
                            Picker("Select Player 1", selection: $player1) {
                                ForEach(players, id: \.self) {player in
                                    Text(player.name)
                                        .tag(Optional(player))
                                        .font(.system(size: 69))
                                }
                            }
                            .pickerStyle(.menu)
                            .controlSize(.small)
                            
                            TextField("Score 1", value: $score1, format: .number).keyboardType(.numberPad)
                                .font(.system(size: 69))
                                .keyboardType(.numberPad)
                                .autocorrectionDisabled()
                        }
                        Spacer()
                        VStack {
                            Picker("Select Player 2", selection: $player2) {
                                ForEach(players, id: \.self) {player in
                                    Text(player.name).tag(Optional(player))
                                    
                                }
                                
                            }
                            .controlSize(.extraLarge)
                            .pickerStyle(.menu)
                            .font(.system(size:69))
                            
                            TextField("Score 2", value: $score2, format: .number)
                                .font(.system(size: 69))
                                .keyboardType(.numberPad)
                                .autocorrectionDisabled()
                            
                        }
                        Spacer()
                    }
                    Button(action: {saveGame()},label: {
                        Text("SUBMIT")
                            .font(Font.system(size:50, design: .monospaced))
                            .padding(.horizontal, 2)
                            .frame(width: 275,height: 90)
                            .foregroundColor(.blue.opacity(1))
                            .background(.gray.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                            .focusable()
                    })
                }
                .navigationTitle("Results")
            }
            .onAppear() {
                setDefaultPlayers()
            }
            .frame(minWidth: 350, idealWidth: 420, maxWidth: 600, minHeight: 100, idealHeight: 150, maxHeight: 250)
        }
        else {
            VStack{
                Text("Error: must have at least two saved players")
                Button("Add Player") {
                    isAddPlayerViewPresented.toggle()
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .popover(isPresented: $isAddPlayerViewPresented) {
                        AddPlayerView(players: $players)
                            .frame(minWidth: 600, minHeight: 200)
                        
                    }
                
            }
        }
    }
    func saveGame() {
        let index1 = players.firstIndex(of: player1) ?? -1
        let index2 = players.firstIndex(of: player2) ?? -1
        if (index1 != -1) && (index2 != -1) {
            players[index1].gameHistory.append(Game(player1, score1!, player2, score2!))
            players[index2].gameHistory.append(Game(player2, score2!, player1, score1!))
            DataController.shared.saveData(players)
        } else {
            print("error saving game")
        }
        print(players.description)
        
        score1 = nil
        score2 = nil
        
    }
}

