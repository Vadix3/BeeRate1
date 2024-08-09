//
//  ViewController.swift
//  BeeRate
//
//  Created by Vadim Kandaurov on 25/07/2024.
//

import UIKit

class RatingViewController: UIViewController {
    
    // Stars
    @IBOutlet weak var star0: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    
    
    // UI Elements
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var clickToUploadImageLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var submitRatingBtn: UIButton!
    
    // Variables
    private var currentRating = 0; // This var will hold the current rating of the beer
    private var editingRating = false; // This boolean will indicate if the rating is in edit mode
    
    // A rating that can be passed from a different view.
    var rating: Rating?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("RatingViewController: View loaded: RatingView!!")
        setGestureRecognizers()
        
        // Check if I got a rating to edit or continue regularely.
        if let rating = rating {
            // Use the rating data to update the UI
            print("Received rating: \(rating)")
            self.isEditing=true
            populateReceivedRating()
        }else{
            print("RatingViewController: Did not receive a rating, clean window")
        }
        
        
    }
    
    func populateReceivedRating(){
        print("RatingViewController: populateReceivedRating")
        
        // Load the image from the url
        Tools.loadImage(from: self.rating!.imageUrl){
            image in
            self.uploadImageView.image = image
        }
        
        // Set name text
        nameTextField.text = self.rating?.name
        
        // Set type text
        typeTextField.text = self.rating?.type
        
        // Set description text
        descriptionTextField.text = self.rating?.reatingDescription
        
        // Set current rating
        currentRating = rating!.rating
        
        // Paint the stars
        updateRatingStars(starIndex: currentRating-1)
        
        // Set the button text
        submitRatingBtn.setTitle("Update rating", for: .normal)
        
    }
    
    /**
     This function will set the gesture recognizers for all the images in the view.
     The point is to detect the tap, and to perform some action if it happens.
     */
    func setGestureRecognizers() {
        print("RatingViewController: setGestureRecognizers")
        
        // Upload photo image
        let uploadTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadImageTapped(tapGestureRecognizer:)))
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(uploadTapGestureRecognizer)
        
        // Star click recognizers
        let stars = [star0, star1, star2, star3, star4]
        for (_, star) in stars.enumerated() {
            let starTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(starTapped(tapGestureRecognizer:)))
            star?.isUserInteractionEnabled = true
            star?.addGestureRecognizer(starTapGestureRecognizer)
        }
    }
    
    /**
     This function will be invoked once someone will tap the image.
     The point of the function is to get an image from the user using the imagepicker.
     */
    @objc func uploadImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("RatingViewController: uploadImageTapped...")
        let _ = tapGestureRecognizer.view as! UIImageView
        Tools.openImagePicker(controller: self) { selectedImage in
            if let image = selectedImage {
                // Handle the selected image
                print("RatingViewController: Image selected in view controller: \(image)")
                self.uploadImageView.image = image // Assign the new image as the image of the imageview
                self.clickToUploadImageLabel.isHidden = true
            } else {
                // Handle cancellation or error
                print("RatingViewController: Image selection canceled or failed.")
            }
        }
    }
    
    /**
     This function will handle what happens when we click on a star.
     The point is to understand what star is clicked and handle the logic.
     For example star 3 is clicked, then color the first 3 stars, and the rating
     of the beer will be 3.
     */
    @objc func starTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("RatingViewController: starTapped...")
        if let tappedStar = tapGestureRecognizer.view as? UIImageView {
            let starIndex = tappedStar.tag
            print("RatingViewController: Star \(starIndex) tapped")
            currentRating = starIndex+1
            updateRatingStars(starIndex: starIndex)
        }
    }
    
    /**
     This function will update the visual rating of the stars. For example
     */
    func updateRatingStars(starIndex: Int) {
        print("RatingViewController: updateRatingStars: \(starIndex)")
        // Array of all the stars
        let stars = [star0, star1, star2, star3, star4]
        
        // Loop through the array
        for (index, star) in stars.enumerated() {
            if index <= starIndex { // if the current star index is lower than or equal to the clicked star
                star?.image = UIImage(systemName: "star.fill") // Change the UI to filled star
                star?.tintColor = .systemYellow // Change the color to gold
            } else {
                star?.image = UIImage(systemName: "star") // Change the UI to unfilled star
                star?.tintColor = .black // Change the color to black
            }
        }
    }
    
    
    
    /**
     This function will handle the rating submittion button click
     */
    @IBAction func onClickSubmit(_ sender: UIButton) {
        print("RatingViewController: Click submit...")
        submitRatingBtn.isEnabled=false
        validateInput()
    }
    
    /**
     This function will validate the input for:
     - Image
     - Rating
     - Name
     - Type
     - Descriptionlabel
     */
    func validateInput() {
        print("RatingViewController: validateInput")
        
        // Check if an image is uploaded
        if uploadImageView.image == nil || uploadImageView.image == UIImage(systemName: "photo.badge.plus") {
            Tools.showToast(message: "Please upload an image.", time: 3, controller: self)
            return
        }
        
        // Check if a rating is selected
        if currentRating == 0 {
            Tools.showToast(message: "Please select a rating.", time: 3, controller: self)
            return
        }
        
        // Check if the name field is not empty
        guard let name = nameTextField.text, !name.isEmpty else {
            Tools.showToast(message: "Please enter the name of the beer.", time: 3, controller: self)
            return
        }
        
        // Check if the type field is not empty
        guard let type = typeTextField.text, !type.isEmpty else {
            Tools.showToast(message: "Please enter the type of the beer.", time: 3, controller: self)
            return
        }
        
        // Check if the description field is not empty
        guard let description = descriptionTextField.text, !description.isEmpty else {
            Tools.showToast(message: "Please enter a description.", time: 3, controller: self)
            return
        }
        
        uploadImageAndHandleResult()
    }
    
    
    
    /**
     This function is responsible for validating and uploading the image to the cloud
     */
    func uploadImageAndHandleResult() {
        print("RatingViewController: uploadImageAndHandleResult")
        guard let image = uploadImageView.image else {
            print("RatingViewController: No image to upload.")
            Tools.showToast(message: "No image to upload.", time: 3, controller: self)
            return
        }
        
        // Firebase section to upload the image. In theory could be changed to any other service like AWS S3 for example.
        FirebaseController.shared.uploadImage(image) { result in
            switch result {
            case .success(let imageUrl):
                print("RatingViewController: Image uploaded successfully: \(imageUrl)")
                self.handleSuccessfulImageUpload(imageUrl: imageUrl)
            case .failure(let error):
                print("RatingViewController: Error uploading image: \(error)")
                Tools.showToast(message: "Failed to upload image. Please try again.", time: 3, controller: self)
            }
        }
    }
    
    
    // Sort of callback function to handle the result of the upload
    func handleSuccessfulImageUpload(imageUrl: String) {
        print("RatingViewController: Handling successful image upload with URL: \(imageUrl)")
        
        // Create a new rating object for uploading or updating
        let newRating = Rating(imageUrl: imageUrl, rating: currentRating, name: nameTextField.text!, type: typeTextField.text!, reatingDescription: descriptionTextField.text!)
        
        if(isEditing){
            print("RatingViewController: Is in edit mode, no need to create a new rating")
            newRating.id=self.rating!.id // Set the id to be the same as the old one
            self.updateRating(newRating:newRating)
        }else{
            print("RatingViewController: NOT in edit mode, need to create a new rating")
            self.createRating(newRating:newRating)
        }
    }
    
    /**
     This function will gather all the data to a Rating object, and will upload the new rating to Firebase
     */
    func createRating(newRating:Rating) {
        print("RatingViewController: createRating")
        printAllValues()
        
        FirebaseController.shared.uploadRating(newRating) { result in
            switch result {
            case .success():
                print("RatingViewController: Rating uploaded successfully!")
                Tools.showToast(message: "Rating submitted successfully!", time: 3, controller: self)
                // Move to the next view if needed
                Tools.moveToScene(scene: "rating_to_submitted", controller: self)
            case .failure(let error):
                print("RatingViewController: Error uploading rating: \(error)")
                Tools.showToast(message: "Failed to upload rating. Please try again.", time: 3, controller: self)
            }
        }
    }
    
    
    /**
     This function will update the rating
     */
    func updateRating(newRating:Rating){
        print("RatingViewController: updateRating")
        printAllValues()
        // Generally should be handled by the server via some api, but for the purpose
        // of this task it will be enough
        FirebaseController.shared.updateRating(newRating) {
            result in
            switch result {
            case .success():
                print("RatingViewController: Rating updated successfully!")
                Tools.showToast(message: "Rating updated successfully!", time: 3, controller: self)
                // Move to the next view if needed
                Tools.moveToScene(scene: "rating_to_submitted", controller: self)
            case .failure(let error):
                print("RatingViewController: Error uploading rating: \(error)")
                Tools.showToast(message: "Failed to update rating. Please try again.", time: 3, controller: self)
            }
        }
    }
    
    /**
     This function will print all the values for logging
     */
    func printAllValues() {
        print("RatingViewController: Printing all values:")
        
        // Print the image (will print Optional(...) if an image is set, nil otherwise)
        print("Image: \(uploadImageView.image?.description ?? "No image")")
        
        // Print the current rating
        print("Rating: \(currentRating)")
        
        // Print the text field values
        print("Name: \(nameTextField.text ?? "No name")")
        print("Type: \(typeTextField.text ?? "No type")")
        print("Description: \(descriptionTextField.text ?? "No description")")
    }
}

