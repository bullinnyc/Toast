//
//  ToastStyle.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 13.05.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

/// ToastStyle.
public struct ToastStyle {
    // MARK: - Public Enums
    
    /// An alignment position for image along the horizontal axis.
    public enum ToastImageAlignment {
        case leading, trailing
    }
    
    /// An alignment position for text along the horizontal axis.
    public enum ToastTextAlignment {
        case leading, center, trailing
        
        var toTextAlignment: TextAlignment {
            switch self {
            case .leading:
                .leading
            case .center:
                .center
            case .trailing:
                .trailing
            }
        }
    }
    
    // MARK: - Public Properties
    
    let titleTextColor: UIColor
    let titleTextAlignment: ToastTextAlignment
    let titleFont: UIFont
    let titleLineLimit: Int
    let messageTextColor: UIColor
    let messageTextAlignment: ToastTextAlignment
    let messageFont: UIFont
    let messageLineLimit: Int
    let backgroundColor: UIColor
    let cornerRadius: CGFloat
    let imageAlignment: ToastImageAlignment
    let isImageAnimation: Bool
    
    // MARK: - Initializers
    
    /// - Parameters:
    ///   - titleTextColor: Title text color.
    ///   - titleTextAlignment: Title text alignment.
    ///   - titleFont: Title font.
    ///   - titleLineLimit: Title line limit.
    ///   - messageTextColor: Message text color.
    ///   - messageTextAlignment: Message text alignment.
    ///   - messageFont: Message font.
    ///   - messageLineLimit: Message line limit.
    ///   - backgroundColor: Toast background color.
    ///   - cornerRadius: Toast corner radius.
    ///   - imageAlignment: Image alignment.
    ///   - isImageAnimation: Set to `true` for animation of the image.
    public init(
        titleTextColor: UIColor? = nil,
        titleTextAlignment: ToastTextAlignment? = nil,
        titleFont: UIFont? = nil,
        titleLineLimit: Int = 1,
        messageTextColor: UIColor,
        messageTextAlignment: ToastTextAlignment = .leading,
        messageFont: UIFont = .seravek(size: 16),
        messageLineLimit: Int = 0,
        backgroundColor: UIColor,
        cornerRadius: CGFloat = 21,
        imageAlignment: ToastImageAlignment = .trailing,
        isImageAnimation: Bool = false
    ) {
        self.titleTextColor = titleTextColor ?? messageTextColor
        self.titleTextAlignment = titleTextAlignment ?? messageTextAlignment
        self.titleFont = titleFont ?? messageFont
        self.titleLineLimit = titleLineLimit
        self.messageTextColor = messageTextColor
        self.messageTextAlignment = messageTextAlignment
        self.messageFont = messageFont
        self.messageLineLimit = messageLineLimit
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.imageAlignment = imageAlignment
        self.isImageAnimation = isImageAnimation
    }
}

// MARK: - Ext. Toast styles

extension ToastStyle {
    /// An object that stores specific toast style.
    public static var space: ToastStyle {
        ToastStyle(
            titleTextColor: RM.day,
            titleTextAlignment: .leading,
            titleFont: .seravekMedium(size: 24),
            titleLineLimit: 1,
            messageTextColor: RM.day,
            messageTextAlignment: .leading,
            messageFont: .seravek(size: 16),
            messageLineLimit: 0,
            backgroundColor: RM.space.withAlphaComponent(0.95),
            cornerRadius: 21,
            imageAlignment: .trailing,
            isImageAnimation: false
        )
    }
    
    /// An object that stores specific toast style.
    public static var mars: ToastStyle {
        ToastStyle(
            titleTextColor: RM.tomato,
            titleTextAlignment: .leading,
            titleFont: .seravekMedium(size: 24),
            titleLineLimit: 1,
            messageTextColor: RM.day,
            messageTextAlignment: .leading,
            messageFont: .seravek(size: 16),
            messageLineLimit: 0,
            backgroundColor: RM.space.withAlphaComponent(0.95),
            cornerRadius: 21,
            imageAlignment: .trailing,
            isImageAnimation: false
        )
    }
}
