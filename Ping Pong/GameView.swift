//
//  GameView.swift
//  Ping Pong
//
//  Created by Luke Botros on 3/26/24.
//

import Foundation
import SwiftUI

struct GameView: View {
    var game: Game
    
    var body: some View {
        VStack{
            Text(String(game.date.formatted(date: .abbreviated, time: .omitted)))
            HStack{
                Spacer()
                VStack{
                    Text(String(game.player1))
                    Text(String(game.score1))
                }
                Spacer()
                VStack{
                    Text(String(game.player2))
                    Text(String(game.score2))
                }
                Spacer()
            }
        }
    }
}
