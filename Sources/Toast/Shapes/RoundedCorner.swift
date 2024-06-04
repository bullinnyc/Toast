//
//  RoundedCorner.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 19.05.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct RoundedCorner: Shape {
    // MARK: - Public Properties
    
    let radius: CGFloat
    let corners: UIRectCorner
    
    // MARK: - Public Methods
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        return Path(path.cgPath)
    }
}

// MARK: - Ext. View

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
