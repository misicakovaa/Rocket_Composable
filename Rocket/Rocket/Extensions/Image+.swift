//
//  ImageExtension.swift
//  Rocket
//
//  Created by Adela Mišicáková on 20.07.2022.
//

import SwiftUI

extension Image {
    static let ui = Image.UI()
    
    struct UI {
        let burn            = Image("Burn")
        let engine          = Image("Engine")
        let fuel            = Image("Fuel")
        let reusable        = Image("Reusable")
        let flyingRocket    = Image("Rocket Flying")
        let idleRocket      = Image("Rocket Idle")
        let rocket          = Image("Rocket")
    }
}
