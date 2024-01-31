//
//  ContentView.swift
//  Ping Pong
//
//  Created by Luke Botros on 9/22/23.
//

import SwiftUI


var players = [Player]()


struct ContentView: View {
    
    @State private var selection = 0
    @State public var players = DataController.shared.loadData()
    var body: some View {
        
        TabView{
            
            
            
            PlayersView()
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
    @State private var selectedPlayers = Set<Player.ID>()
    @State private var sortOrder = [KeyPathComparator(\Player.name),
                                    KeyPathComparator(\Player.elo),
                                    KeyPathComparator(\Player.winPercent),
                                    KeyPathComparator(\Player.wins),
                                    KeyPathComparator(\Player.losses),
                                    KeyPathComparator(\Player.ties)]
    
    
    @State var splitVision: NavigationSplitViewVisibility = .all
    
    var body: some View {
        
        NavigationStack{
            VStack{
                NavigationLink(destination: AddPlayerView()) {
                    Text("Add")
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
                
                .onChange(of: sortOrder) {oldValue, newValue in players.sort(using: sortOrder)}
                .onAppear() {players.sort(using: sortOrder[0])}
                .onChange(of: selectedPlayers) {
                    
                }
            }
        }
        
    }
}

struct ResultsView: View {

  @State private var player1 = ""
  @State private var player2 = ""
  @State private var score1 = ""
  @State private var score2 = ""

  var body: some View {
      VStack{
          HStack {
              VStack {
                  TextField("Player 1", text: $player1)
                  TextField("Score 1", text: $score1)
              }
              
              VStack {
                  TextField("Player 2", text: $player2)
                  TextField("Score 2", text: $score2)
              }
          }
              Button(action: {
                  // Submit action
              }) {
                  Text("Submit")
              }
              .padding(2)
      }
    .navigationTitle("Results")
  }
}


struct AddPlayerView: View {
    
    @State private var nameText = ""
    @State private var eloText = ""
    
    var body: some View {
        
        Button("Save") {
            saveAction()
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
        print(players)
        DataController.shared.saveData(players)
    }
                            
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
