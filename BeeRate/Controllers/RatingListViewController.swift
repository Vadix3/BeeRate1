//
//  ViewController.swift
//  BeeRate
//
//  Created by Vadim Kandaurov on 25/07/2024.
//

import UIKit

class RatingListViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    var ratings: [Rating] = []
    
    var selectedRating: Rating?
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("RatingListViewController: View loaded!")
        fetchRatings()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func printRatings() {
        for rating in ratings {
            print(rating)
        }
    }
    
    func fetchRatings() {
        print("RatingListViewController: fetchRatings")
        FirebaseController.shared.fetchRatings { result in
            switch result {
            case .success(let fetchedRatings):
                self.ratings = fetchedRatings.sorted(by: { $0.createdDate > $1.createdDate }) // Sort by the date
                self.printRatings()
                // Reload the collection view with the fetched data
                self.collectionView.reloadData()
                print("RatingListViewController: Fetch success!")
            case .failure(let error):
                print("RatingListViewController: Error fetching ratings: \(error)")
                Tools.showToast(message: "Failed to fetch ratings. Please try again.", time: 3, controller: self)
            }
        }
    }
    
    
    
    /**
     Specify number of items to be displayed
     */
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("RatingListViewController: collectionView with count: \(self.ratings.count)")
        return self.ratings.count
    }
    
    /**
     Specify the cell
     */
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingCellCollectionViewCell", for: indexPath)as! RatingCellCollectionViewCell
        cell.setup(with: ratings[indexPath.row])
        return cell
    }
    
    /**
     Detect item selection
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedRating = ratings[indexPath.row]
        print("RatingListViewController: Selected rating: \(self.selectedRating!)")
        // Add any additional action you want to perform on item click
        moveToRatingPage()
    }
    
    
    func moveToRatingPage(){
        print("RatingListViewController: moveToRatingPage")
        Tools.moveToScene(scene: "ratingList_to_rating", controller: self)
    }
    
    
    /**
     This function will prepare the data before the segue. The point is, if the user will click on an item in the collectionview,
     it will take the user to the rating page to edit the rating if needed, so we need to send it.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("RatingListViewController: prepare")
        if segue.identifier == "ratingList_to_rating" {
            if let destinationVC = segue.destination as? RatingViewController {
                print("RatingListViewController: Preparing things for next view...")
                destinationVC.rating = self.selectedRating!
            }else{
                print("RatingListViewController: NOTHING TO PREPARE!!")
            }
        }
    }
}

