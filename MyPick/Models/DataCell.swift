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

class DataCell : UITableViewCell {
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //UI SET UP
    private func setupUI(){
        self.contentView.addSubview(dataImageView)
        self.contentView.addSubview(dataTitleText)
        self.contentView.addSubview(connectButton)
        
        dataImageView.translatesAutoresizingMaskIntoConstraints = false
        dataTitleText.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dataImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            dataImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            dataImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            dataImageView.heightAnchor.constraint(equalToConstant: 90),
            dataImageView.widthAnchor.constraint(equalToConstant: 90),
            
            dataTitleText.leadingAnchor.constraint(equalTo: self.dataImageView.trailingAnchor, constant: 16),
            dataTitleText.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            dataTitleText.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            dataTitleText.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            connectButton.widthAnchor.constraint(equalToConstant: 100),
            connectButton.heightAnchor.constraint(equalToConstant: 50), 
            connectButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            connectButton.centerXAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            //connectButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
        ])
        
    }
}
struct Service {
    let name: String
    let url: String
}










/*private func setupUI(){
 self.contentView.addSubview(dataImageView)
 self.contentView.addSubview(dataTitleText)
 
 dataImageView.translatesAutoresizingMaskIntoConstraints = false
 dataImageView.translatesAutoresizingMaskIntoConstraints = false
 
 NSLayoutConstraint.activate([
 dataImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
 dataImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
 dataImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
 dataImageView.heightAnchor.constraint(equalToConstant: 90),
 dataImageView.widthAnchor.constraint(equalToConstant: 90),
 ])*/


/*func setValues(data : Service)
 {
 dataTitleText.text = data.serviceName
 let storageRef = Storage.storage().reference(forURL: data.URL)
 storageRef.getData(maxSize: 28060876) {(data, error) in
 if let err = error {
 print(err)
 }else{
 if let image = data {
 let myImage = UIImage(data: image)
 self.dataImageView.image = myImage
 }
 }
 }
 
 }
 }*/

