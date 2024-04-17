//
//  ContentView.swift
//  Ping Pong
//
//  Created by Luke Botros on 9/22/23.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView{
            PlayersView(sortBy: .name, filterString: "")
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
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
            
        }
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: Player.self)
    }
}
