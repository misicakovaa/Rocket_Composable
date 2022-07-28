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
  var fetch: (String) -> Effect<[Rocket], Failure>

  struct Failure: Error, Equatable {}
}

extension RocketsManager {
  static let live = Self(
    fetch: { urlString in
      Effect.task {
          let apiService = ApiService(urlString: urlString)
          return try await apiService.getData()
      }
      .mapError { _ in Failure() }
      .eraseToEffect()
    }
  )
}
