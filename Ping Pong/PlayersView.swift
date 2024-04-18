//
//  PlayerTableView.swift
//  Ping Pong
//
//  Created by Luke Botros on 3/21/24.
//

import Foundation
import SwiftUI
import SwiftData

struct PlayersView: View {
    @Environment(\.modelContext) private var context
    @Query private var players: [Player]
    @State private var currentSelected: Player
    @State private var selectedPlayers = Set<Player.ID>()
    @State private var isAddPlayerViewPresented: Bool = false
    @State private var filter = ""
    @State private var sortOrder: SortOrder
    
    
    init(sortBy: SortOrder, filterString: String, isAddPlayerViewPresented: Bool = false, sortOrder: SortOrder = SortOrder.name) {
        self.currentSelected = Player(name: "Played")
        self.selectedPlayers = Set<Player.ID>()
        self.isAddPlayerViewPresented = isAddPlayerViewPresented
        self.sortOrder = sortOrder
    }
    
    
    var body: some View {
        NavigationStack{
            TablePlayersView(sortBy: sortOrder, filterString: filter)
                .searchable(text: $filter, placement: .navigationBarDrawer, prompt: Text("Filter by name")).autocorrectionDisabled()
                .toolbar {
                    HStack{
                        Spacer()
                        Button("Add Player") {
                            isAddPlayerViewPresented.toggle()
                        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .popover(isPresented: $isAddPlayerViewPresented) {
                                AddPlayerView()
                                    .frame(minWidth: 600, minHeight: 200)
                                
                            }
                        
                        Picker("", selection: $sortOrder) {
                            ForEach(SortOrder.allCases) { sortOrder in
                                Text("Sort by \(sortOrder.rawValue)").tag(sortOrder)
                            }
                        }
                        .buttonStyle(.bordered)
                        Spacer()
                    }
                }
        }
    }
    
}


struct AddPlayerView: View {
    @Environment(\.modelContext) private var context
    @State private var nameText = ""
    @State private var eloText = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            TextField("Name", text: $nameText).autocorrectionDisabled(true)
            TextField("ELO (Optional)", text: $eloText).keyboardType(.numberPad)
        }.contentMargins(20)
        Button("Save") {
            
            saveAction(context)
            self.presentationMode.wrappedValue.dismiss() // Dismisses the view
        }.padding()
    }
    func saveAction(_ modelContext: ModelContext) {
        let newPlayer = Player(name: nameText, elo: Int(eloText) ?? 800)
        context.insert(newPlayer)
    }
                            
}



struct TablePlayersView: View {
    @Environment(\.modelContext) private var context
    @Query private var players: [Player]
    @State private var selectedPlayers = Set<Player.ID>()
    @State private var sortBy: SortOrder
    @State private var currentSelected: Player
    
    init(sortBy: SortOrder, filterString: String){
        let sortDescriptors: [SortDescriptor<Player>] = switch sortBy {
        case .name: [SortDescriptor(\Player.name)]
        case .elo: [SortDescriptor(\Player.elo)]
        case .wins: [SortDescriptor(\Player.wins)]
        case .losses: [SortDescriptor(\Player.losses)]
        case .ties: [SortDescriptor(\Player.ties)]
        }
        let predicate = #Predicate<Player> { player in
            player.name.localizedStandardContains(filterString)
            || player.name.localizedStandardContains(filterString)
            || filterString.isEmpty
        }
        
        self.sortBy = sortBy
        self.currentSelected = Player(name: "Player")
        _players = Query(filter: predicate, sort: sortDescriptors, animation: .bouncy)
    }
    
    
    var body: some View {
        Table(players, selection: $selectedPlayers) {
            TableColumn("Name", value: \.name)
            TableColumn("Score", value: \.elo.description)
            TableColumn("Win %", value: \.roundedWinPercentage.description)
            TableColumn("Wins", value: \.wins.description)
            TableColumn("Losses", value: \.losses.description)
            TableColumn("Ties", value: \.ties.description)
            TableColumn("Games", value: \.numberGames.description)
        }
        .onAppear() {
            selectedPlayers=Set<Player.ID>()
            currentSelected=Player(name: "Player")
        }
        .onChange(of: selectedPlayers) {
            let arrayIndex = self.selectedPlayers
            let item = players.filter() { arrayIndex.contains($0.id) }
            currentSelected = item.first ?? currentSelected
        }
        .toolbar{
            Button("Delete Player") {
                deleteSelectedPlayers()
            }
            NavigationLink(destination: DetailedPlayerView(player: $currentSelected)) {
                Text("More for \(currentSelected.firstName)").frame(width:150)
            }
        }
        
    }
    private func deleteSelectedPlayers() {
        if (players.first(where: {selectedPlayers.contains($0.id)}) != nil) {
            context.delete(players.first(where: {selectedPlayers.contains($0.id)})!)
            selectedPlayers.removeAll()
            currentSelected=Player(name: "Player")
        } else {return}
    }
}

enum SortOrder: String, Identifiable, CaseIterable {
    case name, elo, wins, losses, ties
    var id: Self {
        self
    }
}
