//
//  RocketRow.swift
//  Rocket
//
//  Created by Adela Mišicáková on 19.07.2022.
//

import SwiftUI

struct RocketRow: View {
    
    let rocketName: String
    let firstFlight: String
    
    var body: some View {
        HStack {
            // Rocket image
            Image.ui.rocket
                .padding(.trailing, 10)
            
            // Rocket name and first flight
            VStack (alignment: .leading) {
                Text(rocketName)
                    .font(.headline)
                
                Text("FirstFlight: \(firstFlight.formateDateString())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding([.top, .bottom], 10)
    }
}

struct RocketRow_Previews: PreviewProvider {
    static var previews: some View {
        RocketRow(rocketName: exampleRocket1.rocketName, firstFlight: exampleRocket1.firstFlight)
    }
}
