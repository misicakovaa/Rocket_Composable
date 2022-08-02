//
//  RocketApp.swift
//  Rocket
//
//  Created by Adela Mišicáková on 11.07.2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct RocketApp: App {
    var body: some Scene {
        WindowGroup {
            RocketsListView(
                store: Store(initialState: AppState(),
                             reducer: appReducer,
                             environment: AppEnvironment(mainQueue: .main, rocketsManager: .live, motionManager: .live)
                            )
            )
        }
    }
}
