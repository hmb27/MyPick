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
    
    let dataImageView = UIImageView()
    let dataTitleText = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        dataImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        contentView.addSubview(dataImageView)
        
        dataTitleText.frame = CGRect(x: 110, y: 0, width: contentView.frame.width - 120,  height: 100)
        contentView.addSubview(dataTitleText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Service {
    let name: String
    let url: String
}

    
    
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
