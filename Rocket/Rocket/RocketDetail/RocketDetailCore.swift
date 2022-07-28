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
}

//MARK: - Reducer

let detailReducer = Reducer<DetailState, DetailAction, DetailEnvironment> { state, action, _  in
    switch action {
    case .launchAction:
        return .none
    }
}
