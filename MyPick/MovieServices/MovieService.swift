//
//  MovieStore.swift
//  MyPick
//
//  Created by Holly McBride on 26/04/2023.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class MovieService {
    static let baseUrl = "https://api.themoviedb.org/3"
    private let apiKey = "07720c1c7b4a216f84b4f61f4e090155"
    
    enum Endpoint: String {
        case nowPlaying = "/movie/now_playing"
        case upcoming = "/movie/upcoming"
        case popular = "/movie/popular"
        
        var url: String {
            return "\(MovieService.baseUrl)\(rawValue)"
        }
    }
    
    enum MovieServiceError: Error {
        case invalidResponseFormat
    }
    
    func fetchMovies(for endpoint: Endpoint, completion: @escaping (Result<[MovieA], Error>) -> Void) {
        let url = endpoint.url + "?api_key=\(apiKey)"
        AF.request(url).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let movieResponse):
                print("Received movie response:", movieResponse)
                let movies: [MovieA]
                if let movieArray = movieResponse.results {
                    // The response is an array
                    movies = movieArray
                } else if let movieDict = movieResponse.result {
                    // The response is a dictionary
                    movies = [movieDict]
                } else {
                    // Unknown response format
                    completion(.failure(MovieServiceError.invalidResponseFormat))
                    return
                }
                completion(.success(movies))
            case .failure(let error):
                print("Error fectching movies:", error)
                completion(.failure(error))
            }
        }
    }

    struct MovieResponse: Decodable {
        let result: MovieA?
        let results: [MovieA]?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let array = try? container.decode([MovieA].self, forKey: .results) {
                results = array
                result = nil
            } else if let dict = try? container.decode(MovieA.self, forKey: .result) {
                result = dict
                results = nil
            } else {
                results = nil
                result = nil
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case result
            case results
        }
    }
}














/*static let shared = MovieStore() //static shared constant -
 private init() {} //only initialised once in the run time
 
 private let apiKey = "07720c1c7b4a216f84b4f61f4e090155"
 private let baseAPIURL = "https://api.themoviedb.org/3/"
 private let urlSession = URLSession.shared
 private let jsonDecoder = Utils.jsonDecoder
 
 
 func fetchMovies(from endpoint: MovieListEndPoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
 guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
 completion(.failure(.invalidEndpoint))
 return
 }
 self.loadUrlAndDecode(url: url, completion: completion)
 }
 
 func fetchMovie(id: Int, completion: @escaping (Result<MovieA, MovieError>) -> ()) {
 guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
 completion(.failure(.invalidEndpoint))
 return
 }
 self.loadUrlAndDecode(url: url, params: [
 "append_to_response": "videos,credits"
 ], completion: completion)
 }
 
 func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
 guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
 completion(.failure(.invalidEndpoint))
 return
 }
 
 self.loadUrlAndDecode(url: url, params: [
 "language": "en-US",
 "include_adult": "false",//does not displaying adult language? look at this
 "region": "US",
 "query": query
 ], completion: completion)
 }
 
 
 private func loadUrlAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()) {
 guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
 completion(.failure(.invalidEndpoint))
 return
 }
 
 var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
 if let params = params {
 queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value)})
 }
 
 urlComponents.queryItems = queryItems
 
 guard let finalURL = urlComponents.url else {
 completion(.failure(.invalidEndpoint))
 return
 }
 
 urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
 guard let self = self else { return }
 if error != nil {
 self.executeCompletionHandlerInMainthread(with: .failure(.apiError), completion: completion)
 return
 }
 
 guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
 self.executeCompletionHandlerInMainthread(with: .failure(.invalidResponse), completion: completion)
 return
 }
 
 guard let data = data else {
 self.executeCompletionHandlerInMainthread(with: .failure(.noData), completion: completion)
 return
 }
 
 //try catch block
 do {
 let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
 self.executeCompletionHandlerInMainthread(with: .success(decodedResponse), completion: completion)
 } catch {
 self.executeCompletionHandlerInMainthread(with: .failure(.serializationError), completion: completion)
 }
 }.resume()
 }
 
 private func executeCompletionHandlerInMainthread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D,
 MovieError>) -> ()) {
 DispatchQueue.main.async {
 completion(result)
 }
 }
 
 }*/
