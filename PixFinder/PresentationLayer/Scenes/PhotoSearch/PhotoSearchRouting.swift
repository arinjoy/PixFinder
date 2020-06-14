//
//  PhotoSearchRouting.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 14/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

protocol PhotoSearchRouting: AnyObject {
    
    /// Presents the details screen of a photo
    func showDetails(forPhoto photo: PhotoViewModel)
}
