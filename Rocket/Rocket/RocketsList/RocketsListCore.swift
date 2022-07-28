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
}

//MARK: - Reducer

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
        
    case .getRockets:
        state.fetchingState = .loading
        
        return environment.rocketsManager.fetch("https://api.spacexdata.com/v3/rockets")
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AppAction.rocketsResponse)
        
    case .rocketsResponse(.success(let rockets)):
        state.rockets = rockets
        state.fetchingState = .success(rockets)
        
        rockets.forEach { rocket in
            state.details[rocket] = DetailState(rocket: rocket)
        }
        
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
        return .none
        
    case .detailAction:
        return .none
    }
}
