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

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    
    detailReducer.optional().pullback(
        state: \.detailState,
        action: /AppAction.detailAction,
        environment: { DetailEnvironment(motionManager: $0.motionManager) }
    ),
    
        .init { state, action, env in
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
                
            case .detailAction:
                return .none
                
            case .setNavigation(selection: .none, detailState: let detailState):
                state.selection = nil
                return .none
                
            case .setNavigation(selection: .some(let selectionId), detailState: let detailState):
                state.selection = Identified(detailState, id: selectionId)
                state.detailState = detailState
                return .none
            }
        }
)

