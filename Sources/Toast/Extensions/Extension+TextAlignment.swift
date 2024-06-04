//
//  Extension+TextAlignment.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 13.05.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

extension TextAlignment {
    // MARK: - Public Properties
    
    var toHorizontalAlignment: Alignment {
        switch self {
        case .leading:
            .leading
        case .center:
            .center
        case .trailing:
            .trailing
        }
    }
    
    var toHorizontalNSTextAlignment: NSTextAlignment {
        switch self {
        case .leading:
            .left
        case .center:
            .center
        case .trailing:
            .right
        }
    }
}
