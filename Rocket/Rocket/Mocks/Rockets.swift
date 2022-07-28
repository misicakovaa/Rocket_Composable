//
//  Mock.swift
//  Rocket
//
//  Created by Adela Mišicáková on 27.07.2022.
//

import Foundation

//MARK: - Rockets

let exampleRocket1 = Rocket(
    id: 1,
    rocketName: "Example Rocket1",
    firstFlight: "28.1.2000",
    description: "Small rocket, not gut",
    height: Height(meters: 0),
    diameter: Diameter(meters: 0),
    mass: Mass(kg: 0),
    firstStage: exampleStage4,
    secondStage: exampleStage1,
    flickrImages: [
        "https://farm1.staticflickr.com/929/28787338307_3453a11a77_b.jpg",
        "https://farm4.staticflickr.com/3955/32915197674_eee74d81bb_b.jpg"
    ])

let exampleRocket2 = Rocket(
    id: 2,
    rocketName: "Example Rocket2",
    firstFlight: "15.11.1993",
    description: "Awesome rocket, very big.",
    height: Height(meters: 1000),
    diameter: Diameter(meters: 200),
    mass: Mass(kg: 808798),
    firstStage: exampleStage2,
    secondStage: exampleStage3,
    flickrImages: [
        "https://farm1.staticflickr.com/929/28787338307_3453a11a77_b.jpg",
        "https://farm4.staticflickr.com/3955/32915197674_eee74d81bb_b.jpg"
    ])

let errorRocket = Rocket(
    id: -1,
    rocketName: "Error Rocket",
    firstFlight: "0.0.0000",
    description: "Error occurred",
    height: Height(meters: 0),
    diameter: Diameter(meters: 0),
    mass: Mass(kg: 0),
    firstStage: exampleStage2,
    secondStage: exampleStage3,
    flickrImages: [])
