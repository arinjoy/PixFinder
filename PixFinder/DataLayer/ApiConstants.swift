//
//  ApiConstants.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

/**
Note: Images are searched at Pixabay.com. Please refer to thier documentation here and
register for own API key based on the subscription type if you have.
 https://pixabay.com/api/docs/
*/

struct ApiConstants {
    
    /// Note:  change to your own PixaBay API key if needed
    static let apiKey = "16961320-8d01719801df9d240a2039336"
    
    static let baseUrl = URL(string: "https://pixabay.com/api")!
}
