//
//  ParameterView.swift
//  Rocket
//
//  Created by Adela Mišicáková on 12.07.2022.
//

import SwiftUI

struct ParameterView: View {
    
    let name: String
    let number: Int
    let unit: String
    
    var body: some View {
        
        let parameterSize = UIScreen.main.bounds.width/4
        
        ZStack {
            Color.ui.rocketPink
            
            VStack {
                Text("\(number)\(unit)")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(name)
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
        }
        .frame(width: parameterSize, height: parameterSize, alignment: .center)
        .cornerRadius(20)
    }
}
