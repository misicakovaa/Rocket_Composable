//
//  StageRow.swift
//  Rocket
//
//  Created by Adela Mišicáková on 20.07.2022.
//

import SwiftUI

struct StageRow: View {
    
    let image: Image
    let text: String
    
    var body: some View {
        HStack {
            image
            
            Text(text)
                .foregroundColor(Color.ui.stagesColor)
            
            Spacer()
            
        }.padding([.leading, .trailing])
    }
}

struct StageRow_Previews: PreviewProvider {
    static var previews: some View {
        StageRow(image: Image.ui.burn, text: "15 seconds burn time")
    }
}
