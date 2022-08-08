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

let detailReducer : Reducer<DetailState, DetailAction, DetailEnvironment> =

launchReducer.pullback(
    state: \.launchState,
    action: /DetailAction.launchAction,
    environment: { LaunchEnvironment(motionManager: $0.motionManager) }
)

