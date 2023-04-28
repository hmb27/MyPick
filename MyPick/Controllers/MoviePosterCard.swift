//
//  MoviePosterCard.swift
//  MyPick
//
//  Created by Holly McBride on 26/04/2023.
//

import Foundation
import SwiftUI

struct MoviePosterCard: View {
    let movie: MovieA
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    .shadow(radius: 4)
                Text(movie.title)
                    .multilineTextAlignment(.center)
            }
        }
        
        .frame(width: 204, height: 306)
        .onAppear {
            self.imageLoader.loadImage(with: self.movie.posterURL)
        
    }
}
}
