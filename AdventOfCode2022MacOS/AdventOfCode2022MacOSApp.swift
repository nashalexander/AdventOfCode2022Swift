//
//  AdventOfCode2022MacOSApp.swift
//  AdventOfCode2022MacOS
//
//  Created by Alex on 12/28/22.
//

import SwiftUI

@main
struct AdventOfCode2022MacOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
