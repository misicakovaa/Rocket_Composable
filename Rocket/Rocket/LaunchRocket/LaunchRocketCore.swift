//
//  LaunchRocketCore.swift
//  Rocket
//
//  Created by Adela Mišicáková on 26.07.2022.
//

import Foundation
import ComposableArchitecture
import ComposableCoreMotion

//MARK: - Environment

struct LaunchEnvironment {
    var motionManager: MotionManager
}

//MARK: - Reducer

let launchReducer = Reducer<LaunchState, LaunchAction, LaunchEnvironment> { state, action, environment in
    
    struct MotionManagerId: Hashable {}
    
    switch action {
        
    case .launchRocket:
        state.launchRocket = true
        return .none
        
        //MARK: - Start analyzing
        
    case .startAnalyzing:
        return .concatenate(
            environment.motionManager
                .create(id: MotionManagerId())
                .fireAndForget(),
            
            environment.motionManager
                .startDeviceMotionUpdates(id: MotionManagerId(), using: .xMagneticNorthZVertical, to: .main)
                .mapError { $0 as NSError }
                .catchToEffect()
                .map(LaunchAction.motionUpdate)
        )
        
        //MARK: - Stop Analyzing
        
    case .stopAnalyzing:
        return .concatenate(
            environment.motionManager
                .stopDeviceMotionUpdates(id: MotionManagerId())
                .fireAndForget(),
            
            environment.motionManager
                .destroy(id: MotionManagerId())
                .fireAndForget()
        )
        
        //MARK: - Successed motion update
        
    case let .motionUpdate(.success(deviceMotion)):
        
        let pitch = deviceMotion.attitude.roll // TODO: Why does roll behave like pitch???
        
        if state.isFirstData && pitch != 0.0 {
            state.pitch = pitch
            state.isFirstData = false
        }
        
        // Setting movement tolerance
        let lowerBound = pitch - 0.5
        let higherBound = pitch + 0.5
        
        // check if new gyroscope data are NOT within the tolerance
        let tolerance = lowerBound...higherBound
        
        if tolerance.contains(state.pitch) == false {
            // stop analyzing
            state.launchRocket = true
        }
        return .none
        
        //MARK: - Failed motion update
        
    case let .motionUpdate(.failure(error)):
        // Do something with the motion update failure
        print("Motion update error")
        return .none
    }
}
