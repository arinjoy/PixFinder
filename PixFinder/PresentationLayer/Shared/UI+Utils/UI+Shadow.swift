//
//  UI+Shadow.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 13/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

/// A simple struct to hold more reusable shadow properties and convenience methods
struct Shadow {

    /// The shadow color. Do not include alpha/opacity in this property.
    let color: UIColor

    /// The shadow's alpha channel amount
    let opacity: CGFloat

    /// The blur radius for the shadow
    let blur: CGFloat

    /// The x/y offset for the shadow
    let offset: CGSize

    init(color: UIColor, opacity: CGFloat, blur: CGFloat, offset: CGSize) {
        self.color = color
        self.opacity = opacity
        self.blur = blur
        self.offset = offset
    }

    /// Will apply the shadow to the given view's layer
    ///
    /// - Parameter view: The view to apply the shadow settings to
    func apply(toView view: UIView) {
        view.layer.shadowOffset = offset
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = Float(opacity)
        view.layer.shadowRadius = blur
    }
}

