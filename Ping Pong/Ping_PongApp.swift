//
//  Ping_PongApp.swift
//  Ping Pong
//
//  Created by Luke Botros on 9/27/23.
//

import SwiftUI
import SwiftData
import CoreData
import CloudKit

@main
struct Ping_PongApp: App {
    let modelContainer: ModelContainer
    
    init(){
        let config = ModelConfiguration(cloudKitDatabase: .private("iCloud.com.lukeb.Ping-Pong"))
        
        
        do {
#if DEBUG
            // Use an autorelease pool to make sure Swift deallocates the persistent
            // container before setting up the SwiftData stack.
            try autoreleasepool {
                let desc = NSPersistentStoreDescription(url: config.url)
                let opts = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.lukeb.Ping-Pong")
                desc.cloudKitContainerOptions = opts
                // Load the store synchronously so it completes before initializing the
                // CloudKit schema.
                desc.shouldAddStoreAsynchronously = false
                if let mom = NSManagedObjectModel.makeManagedObjectModel(for: [Player.self]) {
                    let container = NSPersistentCloudKitContainer(name: "Player", managedObjectModel: mom)
                    container.persistentStoreDescriptions = [desc]
                    container.loadPersistentStores {_, err in
                        if let err {
                            fatalError(err.localizedDescription)
                            
                            //need to find fix to prompt user to sign into iCloud if not signed in on the device
                            
                        }
                    }
                    // Initialize the CloudKit schema after the store finishes loading.
                    try container.initializeCloudKitSchema()
                    // Remove and unload the store from the persistent container.
                    if let store = container.persistentStoreCoordinator.persistentStores.first {
                        try container.persistentStoreCoordinator.remove(store)
                    }
                }
            }
#endif
            modelContainer = try ModelContainer(for: Player.self,
                                                configurations: config)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(.dark)
        }
        .modelContainer(modelContainer)
    }
}
