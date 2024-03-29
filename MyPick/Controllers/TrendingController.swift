//
//  TrendingController.swift
//  MyPick
//
//  Created by Holly McBride on 27/04/2023.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher
import SideMenu

class TrendingController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let popularStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let upcomingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let nowPlayingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let popularLabel: UILabel = {
        let label = UILabel()
        label.text = "New To Netflix This Week"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let upcomingLabel: UILabel = {
        let label = UILabel()
        label.text = "New To Amazon Prime This Week"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let nowPlayingLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Chance To Watch On Disney+"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let movieService = MovieService()
    private var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9686, green: 0.9686, blue: 0.9294, alpha: 1)
        title = "Trending"
    
        //add to scrollView
        view.addSubview(scrollView)
        scrollView.addSubview(popularLabel)
        scrollView.addSubview(popularStackView)
        scrollView.addSubview(upcomingLabel)
        scrollView.addSubview(upcomingStackView)
        scrollView.addSubview(nowPlayingLabel)
        scrollView.addSubview(nowPlayingStackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        popularStackView.translatesAutoresizingMaskIntoConstraints = false
        upcomingStackView.translatesAutoresizingMaskIntoConstraints = false
        nowPlayingStackView.translatesAutoresizingMaskIntoConstraints = false
        
        popularLabel.translatesAutoresizingMaskIntoConstraints = false
        upcomingLabel.translatesAutoresizingMaskIntoConstraints = false
        nowPlayingLabel.translatesAutoresizingMaskIntoConstraints = false
        //Display Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                  
            popularLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            popularLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
                  
            popularStackView.topAnchor.constraint(equalTo: popularLabel.bottomAnchor, constant: 10),
            popularStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            popularStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            popularStackView.heightAnchor.constraint(equalToConstant: 250),
                  
            upcomingLabel.topAnchor.constraint(equalTo: popularStackView.bottomAnchor, constant: 20),
            upcomingLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
                  
            upcomingStackView.topAnchor.constraint(equalTo: upcomingLabel.bottomAnchor, constant: 10),
            upcomingStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            upcomingStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            upcomingStackView.heightAnchor.constraint(equalToConstant: 250),
                  
            nowPlayingLabel.topAnchor.constraint(equalTo: upcomingStackView.bottomAnchor, constant: 20),
            nowPlayingLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
                  
            nowPlayingStackView.topAnchor.constraint(equalTo: nowPlayingLabel.bottomAnchor, constant: 10),
            nowPlayingStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            nowPlayingStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            nowPlayingStackView.heightAnchor.constraint(equalToConstant: 250),
                  
            upcomingStackView.bottomAnchor.constraint(equalTo: nowPlayingLabel.topAnchor, constant: -20),
            popularStackView.bottomAnchor.constraint(equalTo: upcomingLabel.topAnchor, constant: -20),
            nowPlayingStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
        
        movieService.fetchMovies(for: .popular) { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    for movie in movies {
                        let movieView = MovieView()
                        movieView.isUserInteractionEnabled = true
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.didTapMovieView(_:)))
                        movieView.addGestureRecognizer(tapGesture)
                        movieView.configure(with: movie)
                        self?.popularStackView.addArrangedSubview(movieView)
                    }
                }
                
            case .failure(let error):
                print("Error fetching popular movies:", error)
            }
        }
        
        movieService.fetchMovies(for: .upcoming) { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    for movie in movies {
                        let movieView = MovieView()
                        movieView.isUserInteractionEnabled = true
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.didTapMovieView(_:)))
                        movieView.addGestureRecognizer(tapGesture)
                        movieView.configure(with: movie)
                        self?.upcomingStackView.addArrangedSubview(movieView)
                    }
                }
                
            case .failure(let error):
                print("Error fetching popular movies:", error)
            }
        }
        
        movieService.fetchMovies(for: .nowPlaying) { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    for movie in movies {
                        let movieView = MovieView()
                        movieView.isUserInteractionEnabled = true
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.didTapMovieView(_:)))
                        movieView.addGestureRecognizer(tapGesture)
                        movieView.configure(with: movie)
                        self?.nowPlayingStackView.addArrangedSubview(movieView)
                    }
                }
                
            case .failure(let error):
                print("Error fetching popular movies:", error)
            }
        }
    }
    
   @objc private func didTapMovieView(_ sender: UITapGestureRecognizer) {

    }
}

