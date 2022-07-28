//
//  RocketLaunchView.swift
//  Rocket
//
//  Created by Adela Mišicáková on 12.07.2022.
//

import SwiftUI
import CoreMotion
import ComposableArchitecture
import ComposableCoreMotion

//MARK: -State

struct LaunchState: Equatable {
    var launchRocket = false
    var isFirstData = true
    var pitch = 0.0
}

//MARK: - Action

enum LaunchAction: Equatable {
    case launchRocket
    case startAnalyzing
    case stopAnalyzing
    case motionUpdate(Result<DeviceMotion, NSError>)
}

//MARK: - View

struct RocketLaunchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var store: Store<LaunchState, LaunchAction>
    
    init(store: Store<LaunchState,LaunchAction>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                // Launch rocket - change image & text
                if viewStore.launchRocket {
                    Image.ui.flyingRocket
                        .offset(y: -UIScreen.main.bounds.height)
                        .transition(.scale.animation(.default.speed(0.1)))
                    
                    Text("Launch successfull!")
                } else {
                    Image.ui.idleRocket
                    Text("Move your phone up \nto launch the rocket")
                }
            }
            .animation(.default, value: viewStore.launchRocket)
            .onAppear {
                viewStore.send(.startAnalyzing)
            }
            .onDisappear {
                viewStore.send(.stopAnalyzing)
            }
            .toolbar {
                // Title = Launch
                ToolbarItem(placement: .principal) {
                    Text("Launch")
                        .font(.headline)
                }
            }
        }
    }
}
