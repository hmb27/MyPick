//
//  TrendingController.swift
//  MyPick
//
//  Created by Holly McBride on 26/04/2023.
//

import Foundation
import UIKit
import Alamofire //JSON - READING HTTP REQUESTS
import Kingfisher // CACHE IMG


class MovieView: UIView {
    
    
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(posterImageView)
        addSubview(titleLabel)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.widthAnchor.constraint(equalTo: widthAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: MovieA) {
        if let posterPath = movie.posterPath {
            let posterUrlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            let posterUrl = URL(string: posterUrlString)
            posterImageView.kf.setImage(with: posterUrl)
        }
        titleLabel.text = movie.title
        
    }

}































/*let movieService = MovieService()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 movieService.fetchMovies(for: .upcoming) {result in
 switch result {
 case .success(let movies):
 //do something here??
 case .failure(let error):
 print(error.localizedDescription)
 }
 }
 
 movieService.fetchMovies(for: .topRated { result in
 switch result {
 case .success(let movies):
 //do something here??
 case .failure(let error):
 print(error.localizedDescription)
 }
 }
 
 movieService.fetchMovies(for: .popular) { result in
 switch result {
 case. success(let movies):
 // do something with popular nmovies
 case .failure(let error):
 print(error.localizedDescription)
 }
 }
 }*/



























/*private var collectionView: UICollectionView!
 private var movies: [MovieA] = []
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 configureCollectionView()
 loadMovies()
 }
 
 
 private func configureCollectionView() {
 let layout = UICollectionViewFlowLayout()
 layout.scrollDirection = .horizontal
 layout.itemSize = CGSize(width: 200, height: 300)
 layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
 
 collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
 collectionView.translatesAutoresizingMaskIntoConstraints = false
 collectionView.backgroundColor = .white
 collectionView.showsHorizontalScrollIndicator = false
 collectionView.delegate = self
 collectionView.dataSource = self
 collectionView.register(MoviePosterCell.self, forCellWithReuseIdentifier: MoviePosterCell.reuseIdentifier)
 
 view.addSubview(collectionView)
 
 NSLayoutConstraint.activate([
 collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
 collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
 collectionView.topAnchor.constraint(equalTo: view.topAnchor),
 collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
 ])
 }
 
 private func loadMovies() {
 movies = MovieA.stubbedMovies
 collectionView.reloadData()
 }
 }
 
 extension TrendingController: UICollectionViewDataSource {
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 return movies.count
 }
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.reuseIdentifier, for: indexPath) as! MoviePosterCell
 let movie = movies[indexPath.item]
 cell.configure(with: movie)
 return cell
 }
 
 }
 
 
 class MoviePosterCell: UICollectionViewCell {
 
 static let reuseIdentifier = "MoviePosterCell"
 
 private var imageView: UIImageView!
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 configureImageView()
 }
 
 required init ?(coder: NSCoder) {
 fatalError("init(coder:) has not been implemeted")
 }
 
 private func configureImageView() {
 imageView = UIImageView(frame: .zero)
 imageView.translatesAutoresizingMaskIntoConstraints = false
 imageView.contentMode = .scaleAspectFill
 imageView.clipsToBounds = true
 
 contentView.addSubview(imageView)
 
 NSLayoutConstraint.activate([
 imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
 imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
 imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
 imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
 ])
 }
 
 func configure(with movie: MovieA) {
 imageView.load(url: movie.posterURL)
 }
 }
 
 extension UIImageView {
 
 func load(url: URL) {
 DispatchQueue.global().async { [weak self] in
 guard let self = self else { return }
 do {
 let data = try Data(contentsOf: url)
 DispatchQueue.main.async {
 self.image = UIImage(data: data)
 }
 } catch {
 print("Error loading image from url: \(error)")
 }
 }
 }
 }*/



