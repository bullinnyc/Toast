//
//  WillTransitionHandler.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 22.05.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

private struct WillTransitionHandler: UIViewControllerRepresentable {
    // MARK: - Public Properties
    
    let onWillTransition: (_ isFinishTransition: Bool) -> Void
    
    // MARK: - Public Methods
    
    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {}
    
    func makeCoordinator() -> WillTransitionHandlerCoordinator {
        WillTransitionHandlerCoordinator(onWillTransition: onWillTransition)
    }
}

// MARK: - Ext. WillTransitionHandlerCoordinator

extension WillTransitionHandler {
    final class WillTransitionHandlerCoordinator: UIViewController {
        // MARK: - Private Properties
        
        private let onWillTransition: (_ isFinishTransition: Bool) -> Void
        
        // MARK: - Initializers
        
        init(onWillTransition: @escaping (_ isFinishTransition: Bool) -> Void) {
            self.onWillTransition = onWillTransition
            
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Override Methods
        
        override func viewWillTransition(
            to size: CGSize,
            with coordinator: any UIViewControllerTransitionCoordinator
        ) {
            super.viewWillTransition(to: size, with: coordinator)
            
            coordinator.animate(
                alongsideTransition: { [weak self] _ in
                    self?.onWillTransition(false)
                }, completion: { [weak self] _ in
                    self?.onWillTransition(true)
                }
            )
        }
    }
}

// MARK: - Ext. View

extension View {
    func onWillTransition(
        _ perform: @escaping (_ isFinishTransition: Bool) -> Void
    ) -> some View {
        background(
            WillTransitionHandler(onWillTransition: perform)
        )
    }
}
