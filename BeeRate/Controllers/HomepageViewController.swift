//
//  HomepageViewController.swift
//  BeeRate
//
//  Created by Vadim Kandaurov on 27/07/2024.
//

import UIKit
import GoogleGenerativeAI

class HomepageViewController: UIViewController {
    
    @IBOutlet weak var factLabel: UILabel!
    private var genAiApiKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        factLabel.isHidden=true
        // Do any additional setup after loading the view.
        print("HomepageViewController: View loaded!!")
        guard let apiKey = Bundle.main.infoDictionary?["GEMINI_KEY"] as? String else {
            fatalError("API key is missing")
        }
        self.genAiApiKey = apiKey
        Task {
            await fetchFact()
        }
    }
    
    // onClick function to move to new rating
    @IBAction func newRatingClick(_ sender: Any) {
        print("HomepageViewController: newRatingClick")
        Tools.moveToScene(scene: "home_to_new_rating", controller: self)
    }
    
    @IBAction func myRatingsClick(_ sender: Any) {
        print("HomepageViewController: myRatingsClick")
        Tools.moveToScene(scene: "home_to_my_ratings", controller: self)
    }
    
    func fetchFact() async {
        print("HomepageViewController: fetchFact")
        let generativeModel = GenerativeModel(
            // Specify a Gemini model appropriate for your use case
            name: "gemini-1.5-flash",
            apiKey: self.genAiApiKey
        )
        
        let prompt = "Tell me a fun fact or a joke about beer. Make it relatively short"
        do {
            let response = try await generativeModel.generateContent(prompt)
            if let text = response.text {
                print("HomepageViewController: \(text)")
                factLabel.isHidden=false
                factLabel.text=text
            }
        } catch {
            print("HomepageViewController: Failed to fetch fact: \(error)")
        }
    }
}
