//
//  ContentView.swift
//  Ping Pong
//
//  Created by Luke Botros on 9/22/23.
//

import SwiftUI

var players: [Player] = DataController.shared.loadData()

struct ContentView: View {
    @State private var selection = 0
    @State public var players = DataController.shared.loadData()

    var body: some View {
        TabView{
            PlayersView(players: $players)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Players")
                }
                .tag(0)
            
            ResultsView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Results")
                }
                .tag(1)
        }
        .onChange(of: selection) { oldValue, newValue in
            self.selection = newValue
        }
    }
}

struct PlayersView: View {
    @Binding var players: [Player]
    @State private var currentSelected: Player = Player(name: "Player")
    @State private var selectedPlayers = Set<Player.ID>()
    @State private var selectedIndex: Int = 0
    @State private var path = NavigationPath()
    @State private var sortOrder = [KeyPathComparator(\Player.name),
                                    KeyPathComparator(\Player.elo),
                                    KeyPathComparator(\Player.winPercent),
                                    KeyPathComparator(\Player.wins),
                                    KeyPathComparator(\Player.losses),
                                    KeyPathComparator(\Player.ties)]
    
    
    
    var body: some View {
        
        NavigationStack(path: $path){
            VStack{
                HStack{
                    Spacer()
                    NavigationLink(destination: AddPlayerView(players: $players)) {
                        Text("Add")
                    }
                    Spacer()
                    NavigationLink(destination: DetailedPlayerView(player: $currentSelected)) {
                        Text("More for \(players[selectedIndex].name)")
                    }
                    Spacer()
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
                .onChange(of: sortOrder) {oldValue, newValue in players.sort(using: sortOrder)
                    selectedPlayers=Set<Player.ID>()
                }
                .onAppear() {players.sort(using: sortOrder[0])}
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
        
        
    }
}

struct AddPlayerView: View {
    
    @Binding var players: [Player]
    @State private var nameText = ""
    @State private var eloText = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        Button("Save") {
            saveAction()
            self.presentationMode.wrappedValue.dismiss() // Dismisses the view
        }
        VStack {
            Form {
                TextField("Name", text: $nameText)
                TextField("ELO", text: $eloText)
            }.contentMargins(20)
        }
    }
    func saveAction() {
        players.append(Player(name:nameText, elo:Int(eloText) ?? 800))
        DataController.shared.saveData(players)
    }
                            
}

struct ResultsView: View {
  
  @State private var player1: Player?
    @State private var player2: Player?
    @State private var score1: Int?
    @State private var score2: Int?

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.white)
            VStack{
                HStack {
                    VStack {
                        Picker("Select Player 1", selection: $player1) {
                            ForEach(players, id: \.self) {player in
                                Text(player.name)
                                    .tag(Optional(player))
                                    .font(.system(size: 100))
                            }
                        }
                        .pickerStyle(.menu)
                        .controlSize(.small)
                        
                        TextField("Score 1", value: $score1, format: .number).keyboardType(.numberPad)
                            .font(.system(size: 100))
                
                            
                        
                        
                    }
                    
                    VStack {
                        Picker("Select Player 2", selection: $player2) {
                            ForEach(players, id: \.self) {player in
                                Text(player.name).tag(Optional(player))
                                
                            }
                            
                        }
                        .controlSize(.extraLarge)
                        .pickerStyle(.menu)
                        .font(.system(size:100))
                        
                        TextField("Score 2", value: $score2, format: .number)
                            .font(.system(size: 100))
                        
                    }
                    .frame(minWidth: 100, idealWidth: 250, maxWidth: 500, minHeight: 100, idealHeight: 250, maxHeight: 500)
                }
                Button(action: {},label: {
                    Text("SUBMIT")
                        .font(Font.system(size:50, design: .monospaced))
                        .padding(.horizontal, 2)
                        .frame(width: 275,height: 90)
                        .foregroundColor(.blue.opacity(1))
                        .background(.gray.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                
                    })
            }
            .navigationTitle("Results")
        }
    }
}




struct DetailedPlayerView: View {
    @Binding var player: Player
    
    var body: some View {
        Text(player.elo.description)
    }
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
