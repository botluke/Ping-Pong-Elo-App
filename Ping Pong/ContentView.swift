//
//  ContentView.swift
//  Ping Pong
//
//  Created by Luke Botros on 9/22/23.
//

import SwiftUI

struct ContentView: View {

  @State private var selection = 0

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
    .onChange(of: selection) { newValue in
      self.selection = newValue
    }
  }
}

struct PlayersView: View {
    @State private var selectedPlayers = Set<Player.ID>()
    @State private var sortOrder = [KeyPathComparator(\Player.name),
                                    KeyPathComparator(\Player.elo),
                                    KeyPathComparator(\Player.winPercentage),
                                    KeyPathComparator(\Player.wins),
                                    KeyPathComparator(\Player.losses),
                                    KeyPathComparator(\Player.ties)]
    
    @State private var players = [
        Player(name: "Luke B", elo: 1100),
        Player(name: "Michael P", elo: 1200),
        Player(name: "Thommy M", elo: 750),
        Player(name: "Michael E", elo: 1200),
        Player(name: "Jack B", elo: 1150),
        Player(name: "Purpleish", elo:200),
        Player(name: "Chrysler", elo:200)
    ]
   
    
    var body: some View {
        
        Table(players, selection: $selectedPlayers, sortOrder: $sortOrder) {
            TableColumn("Name", value: \.name)
            TableColumn("Score", value: \.eloString)
            TableColumn("Win %", value: \.winPercentageString)
            TableColumn("Wins", value: \.winsString)
            TableColumn("Losses", value: \.lossesString)
            TableColumn("Ties", value: \.tiesString)
        }
        .onChange(of: sortOrder) {
            players.sort(using: $0)
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

  @State private var name = ""
  @State private var elo = ""

  var body: some View {
    VStack {
      TextField("Name", text: $name)
      TextField("ELO", text: $elo)
      
      Button("Save") {
        // Save player
      }
    }
  }
}

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var elo: Int
    var eloString: String {String(elo)}
    var wins: Int = 0
    var winsString: String {String(wins)}
    var losses: Int = 0
    var lossesString: String {String(losses)}
    var ties: Int = 0
    var tiesString: String {String(ties)}
    var numberGames: Int {wins+losses+ties}
    var winPercentage: Double {Double(wins)/Double(numberGames)}
    var winPercentageString: String {String(winPercentage)}
    //Ideally get rid of all the _String variables and replace with one universal one
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
