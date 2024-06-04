//
//  StatusBarConfigurator.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 10.05.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

final class StatusBarConfigurator: ObservableObject {
    // MARK: - Private Classes
    
    private final class ViewController: UIViewController {
        weak var configurator: StatusBarConfigurator?
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return configurator?.statusBarStyle ?? .default
        }
    }
    
    // MARK: - Private Properties
    
    private var window: UIWindow?
    
    private var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - Deinitializers
    
    deinit {
        window = nil
    }
    
    // MARK: - Public Methods
    
    func changeStyle(with statusBarStyle: UIStatusBarStyle) {
        self.statusBarStyle = statusBarStyle
        window?.isHidden = statusBarStyle == .default
    }
    
    // MARK: - Private Methods
    
    fileprivate func prepareWindow(scene: UIWindowScene) {
        if window == nil {
            let window = UIWindow(windowScene: scene)
            
            let viewController = ViewController()
            viewController.configurator = self
            
            window.rootViewController = viewController
            window.frame = scene.screen.bounds
            window.alpha = .zero
            
            self.window = window
        }
        
        window?.windowLevel = .statusBar
        window?.makeKeyAndVisible()
    }
}

private struct SceneFinder: UIViewRepresentable {
    // MARK: - Public Classes
    
    final class View: UIView {
        var onWindowScene: ((UIWindowScene) -> Void)!
        
        override func didMoveToWindow() {
            if let scene = window?.windowScene {
                onWindowScene(scene)
            }
        }
    }
    
    // MARK: - Public Properties
    
    let onWindowScene: (UIWindowScene) -> Void
    
    // MARK: - Public Methods
    
    func makeUIView(context: Context) -> View {
        View()
    }
    
    func updateUIView(_ uiView: View, context: Context) {
        uiView.onWindowScene = onWindowScene
    }
}

// MARK: - Ext. View

extension View {
    func sceneFinder(_ configurator: StatusBarConfigurator) -> some View {
        background(
            SceneFinder { scene in
                configurator.prepareWindow(scene: scene)
            }
        )
    }
}
