//
//  ContentView.swift
//  Ping Pong
//
//  Created by Luke Botros on 9/25/23.
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
    
    @State private var players = [
        Player(name: "Luke B", elo: 1100),
        Player(name: "Michael E", elo: 1200),
        Player(name: "Thommy M", elo: 700),
        Player(name: "Michael P", elo: 1200)
    ]
    private var playersByName: [Player] {
        return players.sorted { $0.name < $1.name }
    }
    
    private var playersByElo: [Player] {
        return players.sorted { $0.elo > $1.elo }
    }
    @State private var sortByElo = false
    @State private var showAddPlayer = false
    
   
    
    
    var body: some View {
        NavigationView {
            VStack {
                    
                List {
                    ForEach(players) { player in
                        HStack {
                            Text(player.name)
                            Spacer()
                            Text("\(player.elo)")
                        }
                    }
                }
                    
                  }
            
            .navigationTitle("Players")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink("Edit", destination: Text("Edit Players"))
                }
                    ToolbarItem(placement: .navigationBarTrailing) {
                            Toggle(isOn: $sortByElo) {
                            Text("Sort by ELO")
                              }
                    }
                  }
                  .sheet(isPresented: $showAddPlayer) {
                    AddPlayerView()
                  }
        }
        .onAppear {
              if sortByElo {
                self.players = playersByElo
              } else {
                self.players = playersByName
              }
            }
        .onChange(of: sortByElo) { newValue in
              if newValue {
                self.players = playersByElo
              } else {
                self.players = playersByName
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
  let name: String
  let elo: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
