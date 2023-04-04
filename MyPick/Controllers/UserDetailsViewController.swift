//
//  UserDetailsViewController.swift
//  MyPick
//
//  Created by Holly McBride on 24/03/2023.
//

import UIKit

class UserDetailsViewController: AccountController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        // RAPID/TMBD API FOR CAROSEL VIEW
        let labelRect = CGRect(x: 50, y: 100, width: 200, height: 100)
        let label = UILabel(frame: labelRect)
        label.text  = "INSIDE USERDETAILS"
        label.numberOfLines = 2
        view.addSubview(label)

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
