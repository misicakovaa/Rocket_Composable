//
//  PhotosSectionView.swift
//  Rocket
//
//  Created by Adela Mišicáková on 13.07.2022.
//

import SwiftUI

struct PhotosSectionView: View {
    
    let images: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Images
            if let safeImages = images {
                ForEach(safeImages, id: \.self) { image in
                    
                    AsyncImage(
                        url: URL(string: image),
                        content: { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .contentShape(RoundedRectangle(cornerRadius: 15))
                        },
                        placeholder: {
                            //Shows progressView while waiting for downloaded image
                            ProgressView()
                        }
                    )
                    .padding([.leading, .trailing, .bottom])
                }
                
            }
        }
    }
}
