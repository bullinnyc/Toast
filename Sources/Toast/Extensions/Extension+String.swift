//
//  Extension+String.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 10.05.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import UIKit

extension String {
    // MARK: - Public Methods
    
    func getTextSize(
        numberOfLines: Int,
        lineBreakMode: NSLineBreakMode,
        alignment: NSTextAlignment,
        font: UIFont,
        width: CGFloat
    ) -> CGSize {
        let label = UILabel(
            frame: CGRect(
                x: .zero,
                y: .zero,
                width: width,
                height: .greatestFiniteMagnitude
            )
        )
        
        label.text = self
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        label.textAlignment = alignment
        label.font = font
        label.sizeToFit()
        
        return label.frame.size
    }
}
