//
//  TitledSection.swift
//  Rocket
//
//  Created by Adela Mišicáková on 20.07.2022.
//

import SwiftUI

struct TitledSection<Content: View>: View {
    
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding()
            
            content
        }
    }
}

struct TitledSection_Previews: PreviewProvider {
    static var previews: some View {
        TitledSection(title: "New Section") {
            Text("Section description")
        }
    }
}
