import Foundation
import UIKit

/**
 This class represents a beer rating.
 It includes:
 - createdDate (Date)
 - image (UIImage)
 - rating (Int)
 - name (String)
 - type (String)
 - reatingDescription (String)
 
 The object should also be stored in Firebase.
 An array of these objects will be shown in the RatingList model.
 */
class Rating: Codable ,CustomStringConvertible{
    var id: String
    var createdDate: Date
    var imageUrl: String
    var rating: Int
    var name: String
    var type: String
    var reatingDescription: String
    
    init(imageUrl: String, rating: Int, name: String, type: String, reatingDescription: String) {
        self.id = UUID().uuidString
        self.createdDate = Date()
        self.imageUrl = imageUrl
        self.rating = rating
        self.name = name
        self.type = type
        self.reatingDescription = reatingDescription
    }
    
    // CustomStringConvertible conformance
    var description: String {
        return """
        
        --------------------------------------------------------------------------------
        
        Rating:
          - ID: \(id)
          - Created Date: \(createdDate)
          - Image URL: \(imageUrl)
          - Rating: \(rating)
          - Name: \(name)
          - Type: \(type)
          - Description: \(reatingDescription)
                
        """
    }
}
