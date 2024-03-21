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
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
