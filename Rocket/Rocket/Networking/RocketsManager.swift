//
//  RocketsManager.swift
//  Rocket
//
//  Created by Adela Mišicáková on 11.07.2022.
//

import Foundation
import Combine
import ComposableArchitecture

struct RocketsManager {
    var fetchRockets: () -> Effect<[Rocket], Failure>
    
    struct Failure: Error, Equatable {}
}

extension RocketsManager {
    static let live = RocketsManager(
        fetchRockets: {
            Effect.task {
                // TODO: inject urlString
                let apiService = ApiService(urlString: "https://api.spacexdata.com/v3/rockets")
                return try await apiService.getData()
            }
            .mapError { _ in Failure() }
            .eraseToEffect()
        }
    )
}
