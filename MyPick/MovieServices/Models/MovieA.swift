//
//  Movie.swift
//  MyPick
//
//  Created by Holly McBride on 26/04/2023.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

struct MovieA: Decodable {
    
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    
    
    private enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
    
}

enum MovieListType: String {
    case upcoming = "Upcoming"
    case popular = "Popular"
}














/*struct MovieResponse: Decodable {
 
 let results: [MovieA]
 
 }
 
 struct MovieA: Decodable, Identifiable {
 //Movie attributes declartions
 let id: Int
 let title: String
 let backdropPath: String?
 let posterPath: String?
 let overview: String
 let voteAverage: Double
 let voteCount: Int
 let runtime: Int?
 
 
 var backdropURL: URL {
 return URL(string: "https://image.tmbd.org/t/p/w500\(backdropPath ?? "")")!
 }
 
 var posterURL: URL {
 return URL(string: "https://image.tmbd.org/t/p/w500\(posterPath ?? "")")!
 }
 }**/
