//
//  RocketListCore.swift
//  Rocket
//
//  Created by Adela Mišicáková on 26.07.2022.
//

import Foundation
import ComposableArchitecture
import ComposableCoreMotion

//MARK: - Environment

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var rocketsManager: RocketsManager
    var motionManager: MotionManager
    var uuid: () -> UUID
}

//MARK: - Reducer

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, env in
    switch action {
        
    case .getRockets:
        state.fetchingState = .loading
        
        return env.rocketsManager.fetchRockets()
            .receive(on: env.mainQueue)
            .catchToEffect()
            .map(AppAction.rocketsResponse)
        
    case .rocketsResponse(.success(let rockets)):
        var details = IdentifiedArrayOf<DetailState>()
        
        rockets.forEach { rocket in
            details.append(
                DetailState(id: env.uuid(), rocket: rocket))
        }
        
        state.fetchingState = .success(details)
        return .none
        
    case .rocketsResponse(.failure(let error)):
        state.fetchingState = .error(error.localizedDescription)
        
        state.alert = .init(
            title: TextState("Error"),
            message: TextState(error.localizedDescription),
            buttons: [.default(TextState("Retry"), action: .send(.getRockets))]
        )
        return .none
        
    case .retry:
        state.alert = nil
        return .init(value: .getRockets)
        
    case .detail(id: let id, action: let action):
        return .none
        
    case .showDetail(let detailState):
        state.presentDetail = true
        state.detailState = detailState
        return .none
        
    case .dismissDetail:
        state.presentDetail = false
        state.detailState = nil
        return .none
        
    case .detailAction:
        return .none
    }
}

