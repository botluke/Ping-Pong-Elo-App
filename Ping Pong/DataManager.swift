//
//  DataManager.swift
//  Ping Pong
//
//  Created by Luke Botros on 1/11/24.
//

import Foundation
import SwiftData

@Model
final class Player {
    //PingPong, ...
    var gameTypes: [String]? = []
    var id: String? = UUID().uuidString
    var name: String
    var elo: Int? = 800
    var wins: Int? = 0
    var losses: Int? = 0
    var ties: Int? = 0
    
    var numberGames: Int {wins!+losses!+ties!}
    var winPercent: Double {Double(wins!)/Double(numberGames)}
    var roundedWinPercentage: Double {
        if numberGames != 0 {(winPercent*10000).rounded()/100}
        else {0.0}
    }
     
    var gameHistory: [Game]? = []
    
    init(name: String, elo: Int? = 800, wins: Int? = 0, losses: Int? = 0, ties: Int? = 0, gameHistory: [Game]? = []) {
        self.id = UUID().uuidString
        self.name = name
        self.elo = elo
        self.wins = wins
        self.losses = losses
        self.ties = ties
        self.gameHistory = gameHistory
    }
    init(name: String, elo: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.elo = elo
        self.wins = 0
        self.losses = 0
        self.ties = 0
        self.gameHistory = []
    }
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
        self.elo = 800
        self.wins = 0
        self.losses = 0
        self.ties = 0
        self.gameHistory = []
    }
}

struct Game: Codable, Identifiable {
    var id: String? = UUID().uuidString
    var player1: String
    var score1: Int
    var player2: String
    var score2: Int
    var date: Date?
    var elo1: Int?
    var elo2: Int?
    
    init(_ firstPlayer: Player, _ firstScore: Int, _ secondPlayer: Player, _ secondScore: Int) {
        player1 = firstPlayer.name
        score1 = firstScore
        player2 = secondPlayer.name
        score2 = secondScore
        date = Date()
        elo1 = firstPlayer.elo!
        elo2 = secondPlayer.elo!
    }
}

/*
 class DataController {
 // UserDefaults key for your data
 private let dataKey = "player_key"
 
 // Singleton instance
 static let shared = DataController()
 
 // Private initializer to ensure a single instance
 private init() {}
 
 // Function to save your array of objects to UserDefaults
 public func saveData(_ data: [Player]) {
 do {
 let encodedData = try JSONEncoder().encode(data)
 UserDefaults.standard.set(encodedData, forKey: dataKey)
 } catch {
 print("Error encoding data: \(error.localizedDescription)")
 }
 }
 
 // Function to retrieve your array of objects from UserDefaults
 func loadData() -> [Player] {
 if let encodedData = UserDefaults.standard.data(forKey: dataKey) {
 do {
 let decodedData = try JSONDecoder().decode([Player].self, from: encodedData)
 return decodedData
 } catch {
 print("Error decoding data: \(error.localizedDescription)")
 }
 }
 //returns an empty array in case no data is stored
 return []
 }
 
 
 
 }
 */
