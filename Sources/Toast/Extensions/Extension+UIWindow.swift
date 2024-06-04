//
//  Extension+UIWindow.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 10.05.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import UIKit

extension UIWindow {
    // MARK: - Public Properties
    
    static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
    
    static var scene: UIWindowScene? {
        return UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first?
            .windowScene
    }
    
    static var screenSize: CGSize {
        return UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first?
            .windowScene?
            .screen
            .bounds
            .size ?? .zero
    }
    
    static var safeAreaInsets: UIEdgeInsets {
        keyWindow?.safeAreaInsets ?? .zero
    }
}
