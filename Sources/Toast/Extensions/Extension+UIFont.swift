//
//  Extension+UIFont.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 19.05.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import UIKit

extension UIFont {
    // MARK: - Public Methods
    
    /// Returns the font object for standard interface items in the specified size.
    ///
    /// - Parameter size: The size (in points) to which the font is scaled.
    /// This value must be greater than 0.0.
    ///
    /// - Returns: A font object of the specified size.
    public static func seravek(size: CGFloat) -> UIFont {
        UIFont(name: "Seravek", size: size) ?? .systemFont(ofSize: size)
    }
    
    /// Returns the font object for standard interface items in the specified size.
    ///
    /// - Parameter size: The size (in points) to which the font is scaled.
    /// This value must be greater than 0.0.
    ///
    /// - Returns: A font object of the specified size.
    public static func seravekMedium(size: CGFloat) -> UIFont {
        UIFont(name: "Seravek-Medium", size: size) ?? .systemFont(ofSize: size)
    }
}
