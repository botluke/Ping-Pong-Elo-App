//
//  DataManager.swift
//  Ping Pong
//
//  Created by Luke Botros on 1/11/24.
//

import Foundation

struct Player: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var elo: Int = 1000
    var wins: Int = 0
    var losses: Int = 0
    var ties: Int = 0
    var numberGames: Int {wins+losses+ties}
    var winPercent: Double {Double(wins)/Double(numberGames)}
    var roundedWinPercentage: Double {
        if numberGames != 0 {(winPercent*10000).rounded()/100}
        else {0.0}
    }
}

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
        return []
    }
    
    
    
}
