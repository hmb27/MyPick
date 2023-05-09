//
//  DataCell.swift
//  MyPick
//
//  Created by Holly McBride on 18/03/2023.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import Kingfisher
import FirebaseStorage

class MovieDataCell : UITableViewCell {
    
    static let identifier = "DataCell"
    
    let dataImageView:  UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .label
        return iv
    }()
    
    let dataTitleText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    let dataDurationText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    let dataGenreText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    let dataRatingText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    let dataYearText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    let dataServiceName: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let connectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Connect", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        contentView.addSubview(dataImageView)
        contentView.addSubview(dataTitleText)
        contentView.addSubview(dataDurationText)
        contentView.addSubview(dataGenreText)
        contentView.addSubview(dataRatingText)
        contentView.addSubview(dataYearText)
        contentView.addSubview(dataServiceName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //UI SET UP
    private func setupUI(){
        self.contentView.addSubview(dataImageView)
        self.contentView.addSubview(dataTitleText)
        self.contentView.addSubview(dataDurationText)
        self.contentView.addSubview(dataGenreText)
        self.contentView.addSubview(dataRatingText)
        self.contentView.addSubview(dataYearText)
        self.contentView.addSubview(dataServiceName)
        self.contentView.addSubview(connectButton)
        dataImageView.translatesAutoresizingMaskIntoConstraints = false
        dataTitleText.translatesAutoresizingMaskIntoConstraints = false
        dataDurationText.translatesAutoresizingMaskIntoConstraints = false
        dataGenreText.translatesAutoresizingMaskIntoConstraints = false
        dataRatingText.translatesAutoresizingMaskIntoConstraints = false
        dataYearText.translatesAutoresizingMaskIntoConstraints = false
        dataServiceName.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dataImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dataImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dataImageView.widthAnchor.constraint(equalToConstant: 90),
            
            dataTitleText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dataTitleText.leadingAnchor.constraint(equalTo: dataImageView.trailingAnchor, constant: 16),
            dataTitleText.trailingAnchor.constraint(equalTo: connectButton.leadingAnchor, constant: -16),
            
            dataDurationText.topAnchor.constraint(equalTo: dataTitleText.bottomAnchor, constant: 8),
            dataDurationText.leadingAnchor.constraint(equalTo: dataTitleText.leadingAnchor),
            dataDurationText.trailingAnchor.constraint(equalTo: dataTitleText.trailingAnchor),
            
            dataGenreText.topAnchor.constraint(equalTo: dataDurationText.bottomAnchor, constant: 8),
            dataGenreText.leadingAnchor.constraint(equalTo: dataTitleText.leadingAnchor),
            dataGenreText.trailingAnchor.constraint(equalTo: dataTitleText.trailingAnchor),
            
            dataRatingText.topAnchor.constraint(equalTo: dataGenreText.bottomAnchor, constant: 8),
            dataRatingText.leadingAnchor.constraint(equalTo: dataTitleText.leadingAnchor),
            dataRatingText.trailingAnchor.constraint(equalTo: dataTitleText.trailingAnchor),
            
            dataYearText.topAnchor.constraint(equalTo: dataRatingText.bottomAnchor, constant: 8),
            dataYearText.leadingAnchor.constraint(equalTo: dataTitleText.leadingAnchor),
            dataYearText.trailingAnchor.constraint(equalTo: dataTitleText.trailingAnchor),
            dataYearText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            dataServiceName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dataServiceName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            
            connectButton.widthAnchor.constraint(equalToConstant: 100),
            connectButton.heightAnchor.constraint(equalToConstant: 50),
            connectButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            connectButton.centerXAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            //connectButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
        ])
        
        
    }
}

struct Movie {
    let movieTitle: String
    let url: String
    let duration: String
    let genre: String
    let imdbRating: String
    let year: String
    let serviceWatchedOn: String
}
