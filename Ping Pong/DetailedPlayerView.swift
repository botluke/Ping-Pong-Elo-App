//
//  DetailView.swift
//  Ping Pong
//
//  Created by Luke Botros on 3/21/24.
//

import Foundation
import SwiftUI

struct DetailedPlayerView: View {
    @Binding var player: Player

    var body: some View {
        Text(player.elo.description)
    }


}
