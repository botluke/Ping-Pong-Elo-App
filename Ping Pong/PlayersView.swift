//
//  PlayerTableView.swift
//  Ping Pong
//
//  Created by Luke Botros on 3/21/24.
//

import Foundation
import SwiftUI

struct PlayersView: View {
    @Binding var players: [Player]
    @State private var currentSelected: Player = Player(name: "Player")
    @State private var selectedPlayers = Set<Player.ID>()
    @State private var selectedIndex: Int = 0
    @State private var path = NavigationPath()
    @State private var isAddPlayerViewPresented: Bool = ContentView().players.count == 0
    @State private var sortOrder = [KeyPathComparator(\Player.name),
                                    KeyPathComparator(\Player.elo),
                                    KeyPathComparator(\Player.winPercent),
                                    KeyPathComparator(\Player.wins),
                                    KeyPathComparator(\Player.losses),
                                    KeyPathComparator(\Player.ties)]
    
    
    
    var body: some View {
        
        NavigationStack{
            VStack{
                HStack{
                    Spacer()
                    NavigationLink(destination: DetailedPlayerView(player: $currentSelected)) {
                        Text("More for \(currentSelected.name)")
                    }
                    Button("Add Player") {
                        isAddPlayerViewPresented.toggle()
                    }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .popover(isPresented: $isAddPlayerViewPresented) {
                            AddPlayerView(players: $players)
                                .frame(minWidth: 600, minHeight: 200)
                            
                        }
                    Button("Delete Player") {
                        deleteSelectedPlayers()
                    }
                    Spacer()
                }
            }
            Table(players, selection: $selectedPlayers, sortOrder: $sortOrder) {
                TableColumn("Name", value: \.name)
                TableColumn("Score", value: \.elo.description)
                TableColumn("Win %", value: \.roundedWinPercentage.description)
                TableColumn("Wins", value: \.wins.description)
                TableColumn("Losses", value: \.losses.description)
                TableColumn("Ties", value: \.ties.description)
                TableColumn("Games", value: \.numberGames.description)
            }
            .onChange(of: sortOrder) {
                oldValue, newValue in players.sort(using: sortOrder)
                selectedPlayers=Set<Player.ID>()
                currentSelected=Player(name: "Player")
                
            }
            .onAppear() {
                players.sort(using: sortOrder[0])
                selectedPlayers=Set<Player.ID>()
                currentSelected=Player(name: "Player")
            }
            .onChange(of: selectedPlayers) {
                //getting selection
                let arrayIndex = self.selectedPlayers
                let item = players.filter() { arrayIndex.contains($0.id) }
                currentSelected = item.first ?? currentSelected
                
                //getting row in [players] of current selection
                var newIndex : Int?
                for (index, elem) in players.enumerated() {
                    if arrayIndex.contains(elem.id) { newIndex = index; break }
                }
                if((newIndex) != nil) {
                    selectedIndex=newIndex!
                }
            }
        }
    }
    private func deleteSelectedPlayers() {
        players.removeAll { player in
            selectedPlayers.contains(player.id)
        }
        selectedPlayers.removeAll()
        currentSelected=Player(name: "Player")
        DataController.shared.saveData(players)
    }
}


struct AddPlayerView: View {
    
    
    @Binding var players: [Player]
    @State private var nameText = ""
    @State private var eloText = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        Form {
            TextField("Name", text: $nameText).autocorrectionDisabled(true)
            TextField("ELO", text: $eloText).keyboardType(.numberPad)
        }.contentMargins(20)
        Button("Save") {
            saveAction()
            self.presentationMode.wrappedValue.dismiss() // Dismisses the view
        }.padding()
    }
    func saveAction() {
        players.append(Player(name:nameText, elo:Int(eloText) ?? 800))
        DataController.shared.saveData(players)
    }
                            
}
