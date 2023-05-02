//
//  MovieDetails.swift
//  MyPick
//
//  Created by Holly McBride on 28/04/2023.
//

import UIKit
import Alamofire
import Kingfisher

class MovieDetails: UIViewController {
    
    var movie: MovieA?
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        if let movie = self.movie {
           // movieView.configure(with: movie)
        }
        //add views to the view hierarchy
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            overviewLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        
        configure(with: movie)
    }
    
    func configure(with movie: MovieA?) {
        guard let movie = movie else { return }
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        if let posterPath = movie.posterPath {
            let posterURL = "https://image.tmdb.org/t/p/w500" + posterPath
            let url = URL(string: posterURL)
            posterImageView.kf.setImage(with: url)
        }
    
    }
}
