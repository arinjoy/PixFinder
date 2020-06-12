//
//  Theme.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 12/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

enum Theme {

    // MARK: - Colors

    static let tealColor = UIColor.colorFrom(red: 25, green: 95, blue: 80)
    static let orangeColor = UIColor.colorFrom(red: 224, green: 100, blue: 27)

    static let lightTealGrayColor = UIColor.colorFrom(red: 226, green: 232, blue: 230)
    static let darkOrangeGrayColor = UIColor.colorFrom(red: 10, green: 6, blue: 3)

    static let tintColor = UIColor(light: Theme.tealColor,
                                   dark: Theme.orangeColor)

    static let backgroundColor =  UIColor(light: UIColor.white,
                                          dark: UIColor.black)

    static let secondaryBackgroundColor = UIColor(light: Theme.lightTealGrayColor,
                                                  dark: Theme.darkOrangeGrayColor)

    static let primaryTextColor = UIColor(light: .darkText,
                                          dark: .lightText)
}

private extension UIColor {
    static func colorFrom(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}

private extension UIColor {

    /// Creates a color object that generates its color data dynamically using the specified colors. For early SDKs creates light color.
    /// - Parameters:
    ///   - light: The color for light mode.
    ///   - dark: The color for dark mode.
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            self.init { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                }
                return light
            }
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
}

