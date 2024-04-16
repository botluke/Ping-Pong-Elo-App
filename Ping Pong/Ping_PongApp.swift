//
//  Ping_PongApp.swift
//  Ping Pong
//
//  Created by Luke Botros on 9/27/23.
//

import SwiftUI
import SwiftData

@main
struct Ping_PongApp: App {
    let modelContainer: ModelContainer
    
    init(){
        do {
            modelContainer = try ModelContainer(for: Player.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
