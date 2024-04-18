//
//  GameInputView.swift
//  Ping Pong
//
//  Created by Luke Botros on 3/21/24.
//

import Foundation
import SwiftUI
import SwiftData


struct ResultsView: View {
    
    @Query private var players: [Player]
    @State private var player1 = Player(name: "Select Player")
    @State private var player2 = Player(name: "Select Player")
    @State private var score1: Int?
    @State private var score2: Int?
    @State private var isAddPlayerViewPresented = false
    @State private var filter = ""
    @State private var search1: String = ""
    @State private var search2: String = ""
    @State private var showAlert = false
    
    
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
                    .foregroundColor(.black)
                VStack{
                    HStack {
                        Spacer()
                        VStack {
                            
                            SearchablePicker(selection: $player1, options: players, searchText: $search1, placeholder: "Search")
                            Text("Selected Player: \(player1.name)")
                                .font(.system(size: 16))
                            
                            TextField("Score 1", value: $score1, format: .number).keyboardType(.numberPad)
                                .font(.system(size: 42))
                                .keyboardType(.numberPad)
                                .autocorrectionDisabled()
                                .background(Color(.systemGray6))
                                .containerShape(RoundedRectangle(cornerRadius: 42))
                        }
                        Spacer()
                        VStack {
                            SearchablePicker(selection: $player2, options: players, searchText: $search2, placeholder: "Search")
                            Text("Selected Player: \(player2.name)")
                                .font(.system(size: 16))
                            
                            TextField("Score 2", value: $score2, format: .number)
                                .font(.system(size: 42))
                                .keyboardType(.numberPad)
                                .autocorrectionDisabled()
                                .background(Color(.systemGray6))
                                .containerShape(RoundedRectangle(cornerRadius: 42))
                            
                        }
                        Spacer()
                    }
                    Button(action: {saveGame()},label: {
                        Text("SUBMIT")
                            .font(Font.system(size:42, design: .monospaced))
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
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("So silly!").font(.system(size: 32)),
                    message: Text("You can't play against yourself").font(.system(size: 24)),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        else {
            VStack{
                Text("Error: must have at least two saved players")
                Button("Add Player") {
                    isAddPlayerViewPresented.toggle()
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .popover(isPresented: $isAddPlayerViewPresented) {
                        AddPlayerView()
                            .frame(minWidth: 600, minHeight: 200)
                        
                    }
                
            }
        }
    }
    func saveGame() {
        let index1 = players.firstIndex(of: player1) ?? -1
        let index2 = players.firstIndex(of: player2) ?? -1
        if index1 != index2 {
            if (index1 != -1) && (index2 != -1) && (score1 != nil) && (score2 != nil){
                players[index1].gameHistory.append(Game(player1, score1!, player2, score2!))
                players[index2].gameHistory.append(Game(player2, score2!, player1, score1!))
                let result = score1!-score2!
                if result > 0 {
                    players[index1].wins += 1
                    players[index2].losses += 1
                } else if result < 0 {
                    players[index1].losses += 1
                    players[index2].wins += 1
                } else {
                    players[index1].ties += 1
                    players[index2].ties += 1
                }
                
                
                //Add elo function to update elos of player1 and player2
                //use players[index1] to reference player1, so the players array gets updated properly
                
            } else {
                print("error saving game")
            }
        } else {
            showAlert = true
        }
        
        score1 = nil
        score2 = nil
        
    }
}
