//
//  RocketsLaunchCoreTest.swift
//  RocketTests
//
//  Created by Adela Mišicáková on 28.07.2022.
//

import XCTest
import Combine
import ComposableArchitecture
import ComposableCoreMotion
@testable import Rocket

class RocketsLaunchCoreTest: XCTestCase {
    
    func test_LaunchRocketCore_MotionUpdates() {
        
        let motionSubject = PassthroughSubject<DeviceMotion, Error>()
        
        let motionManager: MotionManager = .unimplemented(
            create: { _ in .none },
            destroy: { _ in .none },
            deviceMotion: { _ in nil },
            startDeviceMotionUpdates: { _, _, _ in motionSubject.eraseToEffect() },
            stopDeviceMotionUpdates: { _ in
                    .fireAndForget { motionSubject.send(completion: .finished) }
            }
        )
        
        let store = TestStore(
            initialState: LaunchState(),
            reducer: launchReducer,
            environment: LaunchEnvironment(motionManager: motionManager))
        
        let deviceMotion = DeviceMotion(
            attitude: .init(quaternion: .init(x: 1, y: 0, z: 0, w: 0)),
            gravity: CMAcceleration(x: 1, y: 2, z: 3),
            heading: 0,
            magneticField: .init(field: .init(x: 0, y: 0, z: 0), accuracy: .high),
            rotationRate: .init(x: 0, y: 0, z: 0),
            timestamp: 0,
            userAcceleration: CMAcceleration(x: 4, y: 5, z: 6)
        )
        
        var updatedDeviceMotion = deviceMotion
        updatedDeviceMotion.attitude = .init(quaternion: .init(x: 1, y: 1, z: 1, w: 4))
        
        
        store
            .send(.startAnalyzing)
        
        // First data from MotionManager
        store
            .send(.motionUpdate(.success(deviceMotion))) {
                $0.isFirstData = false
                $0.launchRocket = false
                $0.pitch = deviceMotion.attitude.roll
            }
        
        // Same position -> no update
        store
            .send(.motionUpdate(.success(deviceMotion)))
        
        // New position -> launch rocket
        store
            .send(.motionUpdate(.success(updatedDeviceMotion))) {
                $0.launchRocket = true
                $0.pitch = deviceMotion.attitude.roll
            }
        
        // Stop analyzing
        store
            .send(.stopAnalyzing)
        
    }
}
