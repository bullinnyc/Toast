//
//  Extension+UIColor.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 03.06.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

extension UIColor {
    // MARK: - Public Properties
    
    var color: Color {
        Color(uiColor: self)
    }
}
