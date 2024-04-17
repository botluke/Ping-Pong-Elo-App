//
//  DataManager.swift
//  Ping Pong
//
//  Created by Luke Botros on 1/11/24.
//

import Foundation
import SwiftData

@Model
final class Player: Hashable, Identifiable {
    var gameType: GameType = GameType.pingPong
    var id: String = UUID().uuidString
    var firstName: String {String(name.prefix(upTo: name.firstIndex(of: " ") ?? name.endIndex))}
    var lastName: String {String(name.suffix(from: name.firstIndex(of: " ") ?? name.endIndex))}
    var name: String = "Player 1"
    var elo: Int = 800
    var wins: Int = 0
    var losses: Int = 0
    var ties: Int = 0
    
    var numberGames: Int {wins+losses+ties}
    var winPercent: Double {Double(wins)/Double(numberGames)}
    var roundedWinPercentage: Double {
        if numberGames != 0 {(winPercent*10000).rounded()/100}
        else {0.0}
    }
     
    var gameHistory: [Game] = []
    
    init(gameType: GameType = .pingPong, name: String, elo: Int = 800, wins: Int = 0, losses: Int = 0, ties: Int = 0, gameHistory: [Game] = []) {
        self.gameType = gameType
        self.id = UUID().uuidString
        self.name = name
        self.elo = elo
        self.wins = wins
        self.losses = losses
        self.ties = ties
        self.gameHistory = gameHistory
    }
}

enum GameType: String, Identifiable, Hashable, CaseIterable, Codable {
    case pingPong, crokinole
    var id: Self {
        self
    }
    func hash(into hasher: inout Hasher) {
        for gameType in GameType.allCases{
            hasher.combine(gameType)
        }
    }
    
}

struct Game: Codable, Identifiable {
    var id: String = UUID().uuidString
    var player1: String = "Player 1"
    var score1: Int = 0
    var player2: String = "Player 2"
    var score2: Int = 0
    var date: Date = Date.now
    var elo1: Int = 800
    var elo2: Int = 800
    
    init(_ firstPlayer: Player, _ firstScore: Int, _ secondPlayer: Player, _ secondScore: Int) {
        player1 = firstPlayer.firstName
        score1 = firstScore
        player2 = secondPlayer.firstName
        score2 = secondScore
        date = Date()
        elo1 = firstPlayer.elo
        elo2 = secondPlayer.elo
    }
}

