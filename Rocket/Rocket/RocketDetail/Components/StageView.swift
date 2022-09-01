//
//  StageView.swift
//  Rocket
//
//  Created by Adela Mišicáková on 12.07.2022.
//

import SwiftUI

struct StageView: View {
    
    let stage: String
    let reusable: Bool
    let engines: Int
    let fuelTons: Int
    let burnTime: Int
    
    var body: some View {
        
        ZStack {
            Color.ui.grayStageBackground
            
            TitledSection(title: "\(stage) Stage") {
                
                VStack{
                    
                    StageRow(
                        image: Image.ui.reusable,
                        text: reusable ? "reusable" : "not reusable")
                    
                    StageRow(
                        image: Image.ui.engine,
                        text: engines == 1 ? "\(engines) engine" : "\(engines) engines")
                    
                    StageRow(
                        image: Image.ui.fuel,
                        text: "\(fuelTons) tons of fuel")
                    
                    StageRow(
                        image: Image.ui.burn,
                        text: "\(burnTime) seconds burn time")
                    
                }.padding(.bottom)
            }
            .padding()
        }
        .cornerRadius(20)
    }
}
