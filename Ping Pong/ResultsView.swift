//
//  GameInputView.swift
//  Ping Pong
//
//  Created by Luke Botros on 3/21/24.
//

import Foundation
import SwiftUI


struct ResultsView: View {
  
  @State private var player1: Player?
    @State private var player2: Player?
    @State private var score1: Int?
    @State private var score2: Int?

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.white)
            VStack{
                HStack {
                    VStack {
                        Picker("Select Player 1", selection: $player1) {
                            ForEach(players, id: \.self) {player in
                                Text(player.name)
                                    .tag(Optional(player))
                                    .font(.system(size: 100))
                            }
                        }
                        .pickerStyle(.menu)
                        .controlSize(.small)
                        
                        TextField("Score 1", value: $score1, format: .number).keyboardType(.numberPad)
                            .font(.system(size: 100))
                    }
                    
                    VStack {
                        Picker("Select Player 2", selection: $player2) {
                            ForEach(players, id: \.self) {player in
                                Text(player.name).tag(Optional(player))
                                
                            }
                            
                        }
                        .controlSize(.extraLarge)
                        .pickerStyle(.menu)
                        .font(.system(size:100))
                        
                        TextField("Score 2", value: $score2, format: .number)
                            .font(.system(size: 100))
                        
                    }
                    .frame(minWidth: 100, idealWidth: 250, maxWidth: 500, minHeight: 100, idealHeight: 250, maxHeight: 500)
                }
                Button(action: {},label: {
                    Text("SUBMIT")
                        .font(Font.system(size:50, design: .monospaced))
                        .padding(.horizontal, 2)
                        .frame(width: 275,height: 90)
                        .foregroundColor(.blue.opacity(1))
                        .background(.gray.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                
                    })
            }
            .navigationTitle("Results")
        }
    }
}

