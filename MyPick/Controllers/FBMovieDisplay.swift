//
//  FBMovieDisplay.swift
//  MyPick
//
//  Created by Holly McBride on 04/05/2023.
//

import Foundation
import UIKit

class FBMovieDisplay: UIViewController {
    
    var movie: MovieFB?
    
    //UI elements to display movie details
    let titleLabel = UILabel()
    let posterImageView = UIImageView()
    let durationLabel = UILabel()
    let genreLabel = UILabel()
    let imdbRatingLabel = UILabel()
    let yearLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(posterImageView)
        view.addSubview(durationLabel)
        view.addSubview(genreLabel)
        view.addSubview(imdbRatingLabel)
        view.addSubview(yearLabel)
        
        //present the movie details
        if let movie = movie {
            titleLabel.text = movie.movieTtitle
            durationLabel.text = "Duration: \(movie.duration)"
            genreLabel.text = "Duration: \(movie.genre)"
            imdbRatingLabel.text = "Duration: \(movie.imdbRating)"
            yearLabel.text = "Duration: \(movie.year)"
            
            //load the poster image from url
            if let posterURL = URL(string: movie.poster) {
                let task = URLSession.shared.dataTask(with: posterURL) { (data, response, error ) in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.posterImageView.image = image
                        }
                    }
                    
                }
                task.resume()
            }
            
        }
        
    }
}
