//
//  RecentlyWatched.swift
//  MyPick
//
//  Created by Holly McBride on 24/03/2023.
//

import UIKit
import SideMenu
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth
import Kingfisher

class RecentlyWatched:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private var menu: SideMenuNavigationController?
    let reuseIdentifier = "MovieDataCell"
    var serviceArray: [Service] = []
    var db: Firestore!
    var currentUser: User?
    let headerView = UIView()
    let tableView = UITableView()
    var recentMovies: [Movie] = []
    let titleLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        view.backgroundColor = UIColor(red: 0.9686, green: 0.9686, blue: 0.9294, alpha: 1)
        //title = "Recently Watched"
        view.addSubview(headerView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    
        titleLabel.text = "Your Recently Watched:"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieDataCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = UIColor(red: 0.9686, green: 0.9686, blue: 0.9294, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        AuthService.shared.fetchUser { user, error in
          if let error = error {
                print("Error fetching user: /(error.localizedDescription)")
            } else if let user = user {
                self.currentUser = user
                
                //fetch the recently watched movies for the current user
                guard let userUID = Auth.auth().currentUser?.uid else {
                    return
                }
                self.db.collection("users").document(user.userUID ?? "").collection("RecentlyWatched").getDocuments { (querySnapshot, error ) in
                        if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        //Iterate through the recently watched movies and populate the serviceArray with the movie data
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            let movieTitle = data["MovieTitle"] as? String ?? ""
                            let url = data["url"] as? String ?? ""
                            let duration = data["Duration"] as? String ?? ""
                            let genre = data["Genre"] as? String ?? ""
                            let imdbRating = data["IMDB Rating"] as? String ?? ""
                            let year = data["Year"] as? String ?? ""
                            let serviceWatchedOn = data["serviceWatchedOn"] as? String ?? ""
                            let movie = Movie(movieTitle: movieTitle, url: url, duration: duration, genre: genre, imdbRating: imdbRating, year: year, serviceWatchedOn: serviceWatchedOn)
                            self.recentMovies.append(movie)
                            if let documents = querySnapshot?.documents {
                                print("Num of docments retrieved: \(documents.count)")
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MovieDataCell
        let movie = recentMovies[indexPath.row]
        cell.dataTitleText.text = movie.movieTitle
        cell.dataDurationText.text = "Duration: \(movie.duration)"
        cell.dataGenreText.text = "Genre: \(movie.genre)"
        cell.dataRatingText.text = "IMDB Rating: \(movie.imdbRating)"
        cell.dataYearText.text = "Released: \(movie.year)"
        cell.dataServiceName.text = "Watched on: \(movie.serviceWatchedOn)"
        let storageRef = Storage.storage().reference(forURL: movie.url)
        storageRef.getData(maxSize: 28060876) { (data, error) in
            if let err = error {
                print(err)
            } else {
                if let image = data {
                    let myImage = UIImage(data: image)
                    cell.dataImageView.image = myImage
                }
            }
        }
        //cell.dataImageView.kf.setImage(with: URL(string: movie.posterURL))

        //removing current incorrect connect button - UIBUG
        for subview in cell.contentView.subviews {
            if let button = subview as? UIButton {
                button.removeFromSuperview()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentMovies.count
    }
    
    
}






