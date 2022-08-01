//
//  RocketsListCoreTest.swift
//  RocketTests
//
//  Created by Adela Mišicáková on 28.07.2022.
//

import XCTest
import ComposableArchitecture
import XCTestDynamicOverlay
import XCTest
@testable import Rocket

class RocketsListTest: XCTestCase {
    
    func test_RocketsListCore_GetRockets_Success() {
        
        let rockets = [exampleRocket1, exampleRocket2]
        
        let testFetch: ( String ) -> Effect<[Rocket], RocketsManager.Failure> = { _ in
            Effect<[Rocket], RocketsManager.Failure> (value: rockets)
        }
        
        let rocketsManager = RocketsManager(fetch: testFetch)
        
        let store = TestStore(initialState: AppState(),
                              reducer: appReducer,
                              environment: AppEnvironment(mainQueue: .main,
                                                          rocketsManager: rocketsManager))
        
        store
            .send(.getRockets) {
                $0.fetchingState = .loading
            }
        
        // TODO: Scheduler
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 0.1)
        
        store
            .receive(.rocketsResponse(Result.success(rockets))) {
                $0.fetchingState = .success(rockets)
                $0.rockets = rockets
            }
    }
}
