//
//  DetailView.swift
//  Ping Pong
//
//  Created by Luke Botros on 3/21/24.
//

import Foundation
import SwiftUI
import Charts

struct DetailedPlayerView: View {
    @Binding var player: Player
    @State private var selection: Game?
    
    var body: some View {
        VStack{
            Chart {
                ForEach(player.gameHistory, id: \.id) { game in
                    LineMark(x: PlottableValue.value("Date", game.date.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year(.twoDigits))), y: PlottableValue.value("elo1", game.elo1), series: .value("Date", "elo"))
                }
                .foregroundStyle(Color.blue)
                .interpolationMethod(.linear)
                
            }
            .frame(minWidth: 200, idealWidth: 400, maxWidth: 600, minHeight: 300, idealHeight: 420, maxHeight: 700, alignment: .center)
            
            List(player.gameHistory) { game in
                NavigationLink{
                    GameView(game: game)
                } label: {
                    Text("\(game.date.formatted(date: .numeric, time: .omitted)) vs \(game.player2)")
                }
            }
            
            
        }
    }
    
    
}
