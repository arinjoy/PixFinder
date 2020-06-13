//
//  UIAccessibility+Helpers.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 13/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

/// Will hold common accessibility settings with convenience methods for mapping to various elements.
struct AccessibilityConfiguration {
    
    /// Will be mapped to the `accessibilityIdentifier` setting on conforming instances.
    let identifier: String?
    
    /// Will be mapped to the `accessibilityLabel` setting on conforming instances.
    let label: String?
    
    /// Will be mapped to the `accessibilityElements` setting on conforming instances.
    let elements: [Any]?
    
    /// Will be mapped to the `accessibilityValue` setting on conforming instances.
    let value: String?
    
    /// Additional context for accessibility label.
    let hint: String?
    
    /// Will be mapped to the 'accessibilityTraits` setting on conforming instances.
    let traits: UIAccessibilityTraits?
    
    init(
        identifier: String?,
        label: String? = nil,
        elements: [Any]? = nil,
        value: String? = nil,
        hint: String? = nil,
        traits: UIAccessibilityTraits? = nil) {
        self.identifier = identifier
        self.label = label
        self.elements = elements
        self.value = value
        self.hint = hint
        self.traits = traits
    }
    
    // MARK: - Convenience
    
    /// Will map the accessibility configurations to the given view.
    /// Any existing values will be overridden if the configuration setting is not nil.
    ///
    /// - Parameter view: The view to apply to
    func apply(to view: UIView) {
        if let identifier = identifier {
            view.accessibilityIdentifier = identifier
        }
        if let label = label {
            view.accessibilityLabel = label
        }
        if let elements = elements {
            view.accessibilityElements = elements
        }
        if let value = value {
            view.accessibilityValue = value
        }
        if let hint = hint {
            view.accessibilityHint = hint
        }
        if let traits = traits {
            view.accessibilityTraits = traits
        }
    }
}

extension UIAccessibility {
    
    /// Creates combined string by joining multiple text elements.
    /// Potentially used to join many labels next to each other to represent one common enitity as Voice Over text
    static func createCombinedAccessibilityLabel(from stringComponents: [String?]) -> String {
        return stringComponents
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}

