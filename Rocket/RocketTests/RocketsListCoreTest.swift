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
    
    let testScheduler = DispatchQueue.test
    
    func test_RocketsListCore_GetRockets_Success() {
        
        let rockets = [exampleRocket1, exampleRocket2]
        
        let testFetch: ( String ) -> Effect<[Rocket], RocketsManager.Failure> = { _ in
            Effect<[Rocket], RocketsManager.Failure> (value: rockets)
        }
        
        let rocketsManager = RocketsManager(fetch: testFetch)
        
        let store = TestStore(initialState: AppState(),
                              reducer: appReducer,
                              environment: AppEnvironment(mainQueue: self.testScheduler.eraseToAnyScheduler(),
                                                          rocketsManager: rocketsManager, motionManager: .live))
        
        store
            .send(.getRockets) {
                $0.fetchingState = .loading
            }
        
        testScheduler.advance(by: 1)
        
        store
            .receive(.rocketsResponse(Result.success(rockets))) {
                $0.fetchingState = .success(rockets)
                $0.rockets = rockets
            }
    }
}
