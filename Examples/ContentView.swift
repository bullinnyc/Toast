//
//  ContentView.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 04.06.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI
import Toast

struct ContentView: View {
    // MARK: - Property Wrappers
    
    @StateObject private var toast = Toast()
    
    // MARK: - Private Properties
    
    private let singleLineExampleText = "Mars is the fourth planet from the Sun. The surface of Mars is orange-red because it is covered in iron oxide dust, giving it the nickname \"the Red Planet\"."
    
    private let multiLineExampleText = """
    Mars is the fourth planet from the Sun.
    The surface of Mars is orange-red because
    it is covered in iron oxide dust, giving it the
    nickname \"the Red Planet\".
    """
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 24) {
            Button(
                "Show toast with single line text",
                action: {
                    toast.show(
                        title: "MARS",
                        message: singleLineExampleText,
                        style: .mars()
                    ) { isShowToast in
                        print(isShowToast)
                    }
                }
            )
            
            Button(
                "Show toast with multi line text",
                action: {
                    toast.show(
                        title: "MARS",
                        message: multiLineExampleText
                    ) { isShowToast in
                        print(isShowToast)
                    }
                }
            )
            
            Button(
                "Show toast",
                action: {
                    toast.show(message: "Some message")
                }
            )
        }
        .padding(.horizontal, 16)
    }
}
