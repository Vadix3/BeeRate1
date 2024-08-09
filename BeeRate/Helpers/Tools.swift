import Foundation
import UIKit

class Tools: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let shared = Tools()
    
    private var completionHandler: ((UIImage?) -> Void)? // Handle the returned image
    
    /**
     This function will open the image picker
     */
    static func openImagePicker(controller: UIViewController, completion: @escaping (UIImage?) -> Void) {
        print("Tools: openImagePicker")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = shared
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false // Allow editing of the image if needed
        
        shared.completionHandler = completion
        
        controller.present(imagePickerController, animated: true, completion: nil)
    }
    
    /**
     Controller function for the image picker
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Tools: imagePickerController")
        var selectedImage: UIImage? = nil
        if let image = info[.originalImage] as? UIImage {
            // Handle the selected image
            print("Tools: Selected image: \(image)")
            selectedImage = image
        }
        picker.dismiss(animated: true) {
            self.completionHandler?(selectedImage)
        }
    }
    
    /**
     This function will dismiss the image picker
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.completionHandler?(nil)
        }
    }
    
    /**
     This function will move the the new target scene
     */
    static func moveToScene(scene: String, controller: UIViewController) {
        print("Tools: Moving to next scene")
        controller.performSegue(withIdentifier: scene, sender: controller)
    }
    
    /**
     This function will display a toast with the given text for the given amount of seconds
     */
    static func showToast(message: String, time: Int, controller: UIViewController) {
        print("Tools: Showing toast with message: \(message)")
        Toast.show(message: message, controller: controller)
    }
    
    /**
     This function will save the given item in the user defaults
     */
    static func saveToUserDefaults<T>(key: String, value: T) {
        print("Tools: saveToUserDefaults")
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /**
     This function will fetch the requested item from the user defaults
     */
    static func getFromUserDefaults<T>(key: String, as type: T.Type) -> T? {
        print("Tools: getFromUserDefaults")
        return UserDefaults.standard.value(forKey: key) as? T
    }
    
    /**
     This function will wait for the given amount of seconds
     */
    static func waitForCallback(seconds: Int, callback: @escaping () -> Void) {
        print("Tools: waitForCallback")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            callback()
        }
    }
    
    /**
     This function will reset the user defaults and remove everything from it
     */
    static func resetUserDefaults() {
        print("Tools: resetUserDefaults")
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
        }
    }
    
    /**
     This function will load an image from a given url. Image store in a database for example
     */
    static func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
