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
                                    KeyPathComparator(\Player.winPercent),
                                    KeyPathComparator(\Player.wins),
                                    KeyPathComparator(\Player.losses),
                                    KeyPathComparator(\Player.ties)]

    @State public var players = [
        Player(name: "Luke B", elo: 1100, wins: 2, losses: 1),
        Player(name: "Michael P", elo: 1200),
        Player(name: "Thommy M", elo: 750),
        Player(name: "Michael E", elo: 1200),
        Player(name: "Jack B", elo: 1150),
        Player(name: "Purpleish", elo:200),
        Player(name: "Chrysler", elo:200)
    ]

    var body: some View {
        VStack{
            Table(players, selection: $selectedPlayers, sortOrder: $sortOrder) {
                TableColumn("Name", value: \.name)
                TableColumn("Score", value: \.elo.description)
                TableColumn("Win %", value: \.roundedWinPercentage.description)
                TableColumn("Wins", value: \.wins.description)
                TableColumn("Losses", value: \.losses.description)
                TableColumn("Ties", value: \.ties.description)
                TableColumn("Games", value: \.numberGames.description)
            }
            .onChange(of: sortOrder) {players.sort(using: $0)}
            .onAppear() {players.sort(using: sortOrder[0])}
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
          DataController.shared.saveData(players)
      }
    }
  }
}

//struct Player: Identifiable {
//    let id = UUID()
//    var name: String
//    var elo: Int
//    var wins: Int = 0
//    var losses: Int = 0
//    var ties: Int = 0
//    var numberGames: Int {wins+losses+ties}
//    var winPercent: Double {Double(wins)/Double(numberGames)}
//    var roundedWinPercentage: Double {
//        if numberGames != 0 {(winPercent*10000).rounded()/100}
//        else {0.0}
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
