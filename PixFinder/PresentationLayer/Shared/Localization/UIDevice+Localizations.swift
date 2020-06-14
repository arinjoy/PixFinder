//
//  UIDevice+Localizations.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 14/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

extension UIDevice {
    
    /// Returns the language code portion of the current device based on system bundles and settings
    /// Eg. It returns `en` for `en-ES` or `fr` for `fr-FR` and so on.
    func languageCode() -> String {
        
        let systemBundle: Bundle = Bundle.main
        let englishLocale: NSLocale = NSLocale(localeIdentifier: "en")
        let preferredLanguages: [String] = NSLocale.preferredLanguages

        for language: String in preferredLanguages {
            let languageComponents: [String : String] = NSLocale.components(fromLocaleIdentifier: language)

            guard let languageCode: String = languageComponents[NSLocale.Key.languageCode.rawValue] else {
                continue
            }

            // Eg. es_MX.lproj, zh_CN.lproj
            if let countryCode: String = languageComponents[NSLocale.Key.countryCode.rawValue] {
                if systemBundle.path(forResource: "\(languageCode)_\(countryCode)", ofType: "lproj") != nil {
                    // Returns language and country code because it appears that the actual language is coded within the country code as well
                    // For example: zh_CN probably mandarin, zh_HK probably cantonese
                    return language
                }
            }

            // Eg. English.lproj, German.lproj
            if let languageName: String = englishLocale.displayName(forKey: NSLocale.Key.identifier, value: languageCode) {
                if systemBundle.path(forResource: languageName, ofType: "lproj") != nil {
                    return languageCode
                }
            }

            // Eg. pt.lproj, hu.lproj
            if systemBundle.path(forResource: languageCode, ofType: "lproj") != nil {
                return languageCode
            }
        }

        // Default is sent and english is nothing else cane be detected
        return "en"
    }
}
