//
//  HomepageViewController.swift
//  BeeRate
//
//  Created by Vadim Kandaurov on 27/07/2024.
//

import UIKit

class RatingSubmittedController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("RatingSubmittedController: View loaded!")
        // Hide the back button for this view controller
        self.navigationItem.hidesBackButton = true
    }
    @IBAction func onClickRateNewBeer(_ sender: UIButton) {
        print("RatingSubmittedController: onClickRateNewBeer")
        Tools.moveToScene(scene: "submitted_to_newRating", controller: self)
    }
    
    
    @IBAction func onClickGoToRatings(_ sender: UIButton) {
        print("RatingSubmittedController: onClickGoToRatings")
        Tools.moveToScene(scene: "submitted_to_myRatings", controller: self)
    }
}


