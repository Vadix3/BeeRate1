//
//  RatingCellCollectionViewCell.swift
//  BeeRate
//
//  Created by Vadim Kandaurov on 28/07/2024.
//

import UIKit

class RatingCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ratingTitle: UILabel!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var ratingType: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func setup(with rating: Rating){
        ratingTitle.text=rating.name
        ratingType.text=rating.type
        ratingLabel.text = "\(rating.rating)/5"
        hourLabel.text = formatTime(rating.createdDate)
        dateLabel.text = formatDate(rating.createdDate)
        
        // Load the image from the url
        Tools.loadImage(from: rating.imageUrl){
            image in
            self.beerImage.image = image
        }
        
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    
}
