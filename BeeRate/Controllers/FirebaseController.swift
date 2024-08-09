import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseDatabase

import UIKit


/**
 This is the firebase controller class that will be resposible for fetching and storing documents in it.
 */
class FirebaseController {
    
    static let shared = FirebaseController()
    private let dbRef = Database.database().reference()
    private let storage = Storage.storage()
    
    
    init() {}
    
    /**
     This function will be resposible for uploading an image to firebase storage and returning a url for it to use
     Thing with images is that they need to be stored somewhere, and Firebase has this capability that will give us a link to use
     Similar to S3 in AWS.
     */
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("beer_photos/\(UUID().uuidString).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Invalid Image Data", code: -1, userInfo: nil)))
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imagesRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                imagesRef.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let urlString = url?.absoluteString {
                        completion(.success(urlString))
                    } else {
                        completion(.failure(NSError(domain: "URL Error", code: -1, userInfo: nil)))
                    }
                }
            }
        }
    }
    
    
    /**
     This function will update a rating using the id of the rating as key.
     */
    func updateRating(_ rating: Rating, completion: @escaping (Result<Void, Error>) -> Void) {
        let ratingId = rating.id  // Assuming rating.id is a non-optional String
        
        let ratingRef = dbRef.child("ratings").child(ratingId)
        
        do {
            let ratingData = try JSONEncoder().encode(rating)
            let jsonObject = try JSONSerialization.jsonObject(with: ratingData, options: [])
            if let jsonDict = jsonObject as? [String: Any] {
                ratingRef.updateChildValues(jsonDict) { error, _ in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    /**
     This function will upload the given rating to firebase
     */
    func uploadRating(_ rating: Rating, completion: @escaping (Result<Void, Error>) -> Void) {
        let ratingId = rating.id
        let ratingRef = dbRef.child("ratings").child(ratingId)
        
        do {
            let ratingData = try JSONEncoder().encode(rating)
            let jsonObject = try JSONSerialization.jsonObject(with: ratingData, options: [])
            if let jsonDict = jsonObject as? [String: Any] {
                ratingRef.setValue(jsonDict) { error, _ in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        print("FirebaseController: UPLOAD RATING SUCCESS")
                        completion(.success(()))
                    }
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    /**
     This function will fetch all the ratings from firebase
     */
    func fetchRatings(completion: @escaping (Result<[Rating], Error>) -> Void) {
        dbRef.child("ratings").observeSingleEvent(of: .value) { snapshot in
            var ratings: [Rating] = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let ratingData = childSnapshot.value as? [String: Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: ratingData, options: [])
                        let rating = try JSONDecoder().decode(Rating.self, from: jsonData)
                        ratings.append(rating)
                    } catch let error {
                        completion(.failure(error))
                        return
                    }
                }
            }
            
            completion(.success(ratings))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
}
