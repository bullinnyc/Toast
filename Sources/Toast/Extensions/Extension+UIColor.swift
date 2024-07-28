//
//  Extension+UIColor.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 03.06.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

extension UIColor {
    // MARK: - Public Enums
    
    enum Brightness {
        case transparent, light, dark
    }
    
    // MARK: - Public Properties
    
    var brightness: Brightness {
        guard let components = cgColor.components,
              components.count > 2
        else { return .dark }
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let brightness = (red * 299 + green * 587 + blue * 114) / 1000
        
        switch alpha {
        case ..<0.5:
            return .transparent
        default:
            return brightness > 0.5 ? .light : .dark
        }
    }
    
    var color: Color {
        Color(uiColor: self)
    }
}
