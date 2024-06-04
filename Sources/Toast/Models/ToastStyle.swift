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
    public enum ImageAlignment {
        case leading, trailing
    }
    
    // MARK: - Public Properties
    
    let titleTextColor: Color
    let titleTextAlignment: TextAlignment
    let titleFont: UIFont
    let titleLineLimit: Int
    let messageTextColor: Color
    let messageTextAlignment: TextAlignment
    let messageFont: UIFont
    let messageLineLimit: Int
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let image: UIImage?
    let imageAlignment: ImageAlignment
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
    ///   - image: Image to be displayed.
    ///   - imageAlignment: Image alignment.
    ///   - isImageAnimation: Set to `true` for animation of the image.
    public init(
        titleTextColor: Color? = nil,
        titleTextAlignment: TextAlignment = .leading,
        titleFont: UIFont = UIFont.seravekMedium(size: 24),
        titleLineLimit: Int = 1,
        messageTextColor: Color,
        messageTextAlignment: TextAlignment = .leading,
        messageFont: UIFont = UIFont.seravek(size: 16),
        messageLineLimit: Int = 0,
        backgroundColor: Color,
        cornerRadius: CGFloat = 21,
        image: UIImage? = nil,
        imageAlignment: ImageAlignment = .trailing,
        isImageAnimation: Bool = false
    ) {
        self.titleTextColor = titleTextColor ?? messageTextColor
        self.titleTextAlignment = titleTextAlignment
        self.titleFont = titleFont
        self.titleLineLimit = titleLineLimit
        self.messageTextColor = messageTextColor
        self.messageTextAlignment = messageTextAlignment
        self.messageFont = messageFont
        self.messageLineLimit = messageLineLimit
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.image = image
        self.imageAlignment = imageAlignment
        self.isImageAnimation = isImageAnimation
    }
}

// MARK: - Ext. Toast styles

extension ToastStyle {
    /// Return specific toast style.
    ///
    /// - Parameter image: Image to be displayed.
    ///
    /// - Returns: Specific `ToastStyle`.
    public static func space(image: UIImage? = nil) -> ToastStyle {
        ToastStyle(
            titleTextColor: RM.day.color,
            titleTextAlignment: .leading,
            titleFont: UIFont.seravekMedium(size: 24),
            titleLineLimit: 1,
            messageTextColor: RM.day.color,
            messageTextAlignment: .leading,
            messageFont: UIFont.seravek(size: 16),
            messageLineLimit: 0,
            backgroundColor: RM.space.color.opacity(0.95),
            cornerRadius: 21,
            image: image,
            imageAlignment: .trailing,
            isImageAnimation: false
        )
    }
    
    /// Return specific toast style.
    ///
    /// - Parameter image: Image to be displayed.
    ///
    /// - Returns: Specific `ToastStyle`.
    public static func mars(image: UIImage? = nil) -> ToastStyle {
        ToastStyle(
            titleTextColor: RM.tomato.color,
            titleTextAlignment: .leading,
            titleFont: UIFont.seravekMedium(size: 24),
            titleLineLimit: 1,
            messageTextColor: RM.day.color,
            messageTextAlignment: .leading,
            messageFont: UIFont.seravek(size: 16),
            messageLineLimit: 0,
            backgroundColor: RM.space.color.opacity(0.95),
            cornerRadius: 21,
            image: image,
            imageAlignment: .trailing,
            isImageAnimation: false
        )
    }
}
