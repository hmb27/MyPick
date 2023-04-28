//
//  MovieService.swift
//  MyPick
//
//  Created by Holly McBride on 26/04/2023.
//

/**import Foundation
import JSON


protocol MovieService {
    
    func fetchMovies(from endpoint: MovieListEndPoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) // fetching the movie list 
    func fetchMovie(id: Int, completion: @escaping (Result<MovieA, MovieError>) -> ())//fetch single movie
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ())//searching movies
}







// endpoints for move list api
enum MovieListEndPoint: String, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
    
    var description: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .topRated: return "Top rated"
        case .popular: return "Popular"
        }
    }
}

//customised error enum for respresenting error when making api call
enum MovieError: Error, CustomNSError {
case apiError
case invalidEndpoint
case invalidResponse
case noData
case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No Data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}*/
