//
//  LocalizationKeys.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 13/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

/// A parent enum to namespace `LocalizationKeys` conforming key enumerations
enum StringKeys {}

/// Conforming to `LocalizableStrings` will require a method to resolve a localized string via a key.
protocol LocalizationKeys: RawRepresentable {
    
    /// The table or `strings` file to search for keys within
    var table: String? { get }
    
    /// Will return a localized string using the given key, searching through the given localised
    /// bundles and formatting with any given arguments.
    ///
    /// - Parameters:
    ///   - args: List of args to format the localised string with
    /// - Returns: String
    func localized(_ args: CVarArg...) -> String
}

// MARK: - Default implementation

extension LocalizationKeys where Self.RawValue == String {
    
    var table: String? {
        return nil
    }
    
    func localized(_ args: CVarArg...) -> String {
        return String(format: NSLocalizedString(self.rawValue, tableName: table, comment: ""),
                      arguments: args)
    }
}
