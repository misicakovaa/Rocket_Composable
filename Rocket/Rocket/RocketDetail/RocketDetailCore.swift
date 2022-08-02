//
//  RocketDetailCore.swift
//  Rocket
//
//  Created by Adela Mišicáková on 26.07.2022.
//

import Foundation
import ComposableArchitecture
import ComposableCoreMotion

//MARK: - Environment

struct DetailEnvironment {
    var motionManager: MotionManager
}

//MARK: - Reducer

let detailReducer : Reducer<DetailState, DetailAction, DetailEnvironment> = .combine(
    
    launchReducer.pullback(state: \.launchState,
                           action: /DetailAction.launchAction ,
                           environment: { environment in
                               LaunchEnvironment(motionManager: environment.motionManager)
                           }),
    
        .init { state, action, _  in
            switch action {
            case .launchAction:
                return .none
            }
        }
)
