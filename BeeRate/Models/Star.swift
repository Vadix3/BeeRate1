//
//  Star.swift
//  BeeRate
//
//  Created by Vadim Kandaurov on 27/07/2024.
//

/**
 This class will represent the star for the rating. The class will be responsible for the star being active or not and the id of it.
 */
import Foundation

class Star {
    
    private var id: Int // The name of the card and power
    private var isActive: Bool // The image
    
    init(id:Int) {
        self.id = id
        self.isActive = false
    }
    
    
    
}
