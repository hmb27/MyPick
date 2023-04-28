//
//  MovieBackdropCarouselView.swift
//  MyPick
//
//  Created by Holly McBride on 26/04/2023.
//

import Foundation
import SwiftUI

struct MovieBackdropCarouselView: View {
    
    let title: String
    let movies: [MovieA]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(self.movies) { movie in
                        MovieBackdropCard(movie: movie)
                            .frame(width: 272, height: 200)
                            .padding(.leading, movie.id == self.movies.first!.id ?
                                     16:0)
                            .padding(.trailing, movie.id == self.movies.last!.id ?
                                     16:0)
                        
                    }
                }
            }
        }
    }
}

struct MovieBackdropCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        MovieBackdropCarouselView(title: "Latest", movies:
        MovieA.stubbedMovies)
    }
}
