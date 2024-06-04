//
//  ResourcesManager.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 03.06.2024.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

#if canImport(UIKit)
import UIKit

#if os(watchOS)
import SwiftUI
#endif

/// Resources manager typealias.
typealias RM = ResourcesManager

/// Resources manager.
final class ResourcesManager {
    // MARK: - Public Properties
    
    /// An object that stores color data.
    static let day = getColor(with: "day")
    
    /// An object that stores color data.
    static let space = getColor(with: "space")
    
    /// An object that stores color data.
    static let tomato = getColor(with: "tomato")
    
    // MARK: - Public Methods
    
    /// Get image by name.
    ///
    /// - Parameter name: Image name.
    ///
    /// - Returns: An initialized image object or `nil` if the object was not found in the resources.
    static func image(_ name: String) -> UIImage? {
        UIImage(named: name, in: Bundle.module, with: nil)
    }
    
    // MARK: - Private Methods
    
    private static func getColor(with name: String) -> UIColor {
        #if os(watchOS)
        UIColor(Color(name, bundle: Bundle.module))
        #elseif os(iOS) || os(tvOS) || os(visionOS)
        UIColor(
            named: name,
            in: Bundle.module,
            compatibleWith: nil
        ) ?? UIColor()
        #endif
    }
}
#elseif canImport(AppKit)
import AppKit

/// Resources manager typealias.
typealias RM = ResourcesManager

/// Resources manager.
final class ResourcesManager {
    // MARK: - Public Properties
    
    /// An object that stores color data.
    static let day = NSColor(
        named: NSColor.Name("day"),
        bundle: Bundle.module
    )
    
    /// An object that stores color data.
    static let space = NSColor(
        named: NSColor.Name("space"),
        bundle: Bundle.module
    )
    
    /// An object that stores color data.
    static let tomato = NSColor(
        named: NSColor.Name("tomato"),
        bundle: Bundle.module
    ) ?? NSColor()
    
    // MARK: - Public Methods
    
    /// Get image by name.
    ///
    /// - Parameter name: Image name.
    ///
    /// - Returns: An initialized image object or `nil` if the object was not found in the resources.
    static func image(_ name: String) -> NSImage? {
        Bundle.module.image(forResource: NSImage.Name(name))
    }
}
#endif
