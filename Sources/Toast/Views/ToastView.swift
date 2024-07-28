//
//  ToastView.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 10.05.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI
import Combine

struct ToastView: View {
    // MARK: - Property Wrappers
    
    @EnvironmentObject private var toast: Toast
    
    @StateObject private var statusBarConfigurator = StatusBarConfigurator()
    
    @State private var isShowToast = false
    @State private var isBounce = false
    @State private var offset: CGSize = .zero
    
    // MARK: - Public Properties
    
    static let horizontalPadding: CGFloat = 16
    static let sidePadding: CGFloat = 100
    static let bottomPadding: CGFloat = 16
    static let verticalSpacing: CGFloat = 8
    
    static var topPadding: CGFloat {
        UIWindow.safeAreaInsets.top + 16
    }
    
    static var safeAreaInsetsLeft: CGFloat {
        UIWindow.safeAreaInsets.left
    }
    
    static var safeAreaInsetsRight: CGFloat {
        UIWindow.safeAreaInsets.right
    }
    
    // MARK: - Private Properties
    
    private let onRotate: ((_ isFinishTransition: Bool) -> Void)?
    private let onHide: (() -> Void)?
    
    private var isImageOnRight: Bool {
        toast.style.imageAlignment == .trailing
    }
    
    // MARK: - Initializers
    
    init(
        onRotate: ((_ isFinishTransition: Bool) -> Void)?,
        onHide: (() -> Void)?
    ) {
        self.onRotate = onRotate
        self.onHide = onHide
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            if isShowToast {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(toast.style.backgroundColor.color)
                        .frame(height: toast.toastHeight)
                    
                    VStack(spacing: Self.verticalSpacing) {
                        if let title = toast.toast.title {
                            text(
                                title,
                                lineLimit: toast.style.titleLineLimit,
                                font: toast.style.titleFont,
                                textAlignment: toast.style.titleTextAlignment
                                    .toTextAlignment,
                                textColor: toast.style.titleTextColor.color
                            )
                            .frame(height: toast.titleHeight)
                        }
                        
                        text(
                            toast.toast.message,
                            lineLimit: toast.style.messageLineLimit,
                            font: toast.style.messageFont,
                            textAlignment: toast.style.messageTextAlignment
                                .toTextAlignment,
                            textColor: toast.style.messageTextColor.color
                        )
                        .frame(height: toast.messageHeight, alignment: .bottom)
                    }
                    .padding(.top, Self.topPadding)
                    .padding(.bottom, Self.bottomPadding)
                    .padding(
                        isImageOnRight ? .leading : .trailing,
                        Self.horizontalPadding
                    )
                    .padding(
                        isImageOnRight ? .trailing : .leading,
                        toast.toast.image == nil
                            ? Self.horizontalPadding
                            : Self.sidePadding
                    )
                    .padding(.leading, Self.safeAreaInsetsLeft)
                    .padding(.trailing, Self.safeAreaInsetsRight)
                    
                    if let image = toast.toast.image {
                        self.image(image, size: geometry.size)
                            .onAppear {
                                isBounce = toast.style.isImageAnimation
                            }
                    }
                }
                .frame(maxHeight: toast.toastHeight, alignment: .top)
                .roundedCorner(
                    toast.style.cornerRadius,
                    corners: [.bottomLeft, .bottomRight]
                )
            }
        }
        .ignoresSafeArea()
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    onHide?()
                }
        )
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height < .zero, offset == .zero {
                        offset = value.translation
                        onHide?()
                    }
                }
                .onEnded { _ in
                    offset = .zero
                }
        )
        .sceneFinder(statusBarConfigurator)
        .onWillTransition { isFinishTransition in
            onRotate?(isFinishTransition)
        }
        .onReceive(Just(toast.isShowToast)) { newValue in
            guard isShowToast != newValue else { return }
            
            isShowToast = newValue
            
            let statusBarStyle: UIStatusBarStyle
            let brightness = toast.style.backgroundColor.brightness
            
            switch brightness {
            case .transparent:
                statusBarStyle = .default
            case .light:
                statusBarStyle = .darkContent
            case .dark:
                statusBarStyle = .lightContent
            }
            
            statusBarConfigurator.changeStyle(
                with: newValue == true ? statusBarStyle : .default
            )
        }
    }
}

// MARK: - Ext. Configure views

extension ToastView {
    private func text(
        _ text: String,
        lineLimit: Int,
        font: UIFont,
        textAlignment: TextAlignment,
        textColor: Color
    ) -> some View {
        Text(text)
            .lineLimit(lineLimit == .zero ? nil : lineLimit)
            .font(Font(font))
            .multilineTextAlignment(textAlignment)
            .foregroundStyle(textColor)
            .frame(
                maxWidth: .infinity,
                alignment: textAlignment.toHorizontalAlignment
            )
    }
    
    @ViewBuilder
    private func image(_ image: UIImage, size: CGSize) -> some View {
        let imageSideLength = min(
            Self.sidePadding - Self.horizontalPadding * 2,
            toast.messageHeight + 8
        )
        
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: imageSideLength, height: imageSideLength)
            .scaleEffect(isBounce ? 0.9 : 1)
            .animation(
                .linear(duration: 0.8)
                .repeatForever(autoreverses: true),
                value: isBounce
            )
            .padding(
                .top,
                toast.toast.title == nil
                    ? Self.topPadding
                    : Self.topPadding + Self.verticalSpacing + toast.titleHeight
            )
            .padding(.bottom, Self.bottomPadding)
            .padding(
                .horizontal,
                Self.sidePadding * 0.5 - imageSideLength * 0.5
            )
            .padding(.leading, Self.safeAreaInsetsLeft)
            .padding(.trailing, Self.safeAreaInsetsRight)
            .frame(
                maxWidth: size.width,
                maxHeight: size.height,
                alignment: isImageOnRight ? .trailing : .leading
            )
    }
}

// MARK: - Preview

#Preview {
    let toast = Toast()
    
    return VStack(spacing: 24) {
        Button(
            "Show toast with single line text",
            action: {
                toast.show(
                    title: "MARS",
                    message: DataManager.singleLineExampleText,
                    image: RM.image("mars"),
                    style: .mars,
                    deadline: 0
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
                    message: DataManager.multiLineExampleText,
                    deadline: 4
                ) { isShowToast in
                    print(isShowToast)
                }
            }
        )
        
        Button(
            "Show some toast with image",
            action: {
                toast.show(
                    message: DataManager.singleLineExampleText,
                    image: RM.image("mars"),
                    style: ToastStyle(
                        messageTextColor: RM.day,
                        messageLineLimit: 1,
                        backgroundColor: RM.space.withAlphaComponent(0.95),
                        imageAlignment: .trailing,
                        isImageAnimation: true
                    )
                )
            }
        )
        
        Button(
            "Show toast",
            action: { toast.show(message: "Some message") }
        )
        
        Group {
            Button(
                "Cancel next toasts",
                action: { toast.cancelNextToasts() }
            )
            
            Button(
                "Cancel all toasts",
                action: { toast.cancelAllToasts() }
            )
        }
        .foregroundStyle(RM.tomato.color)
    }
    .padding(.horizontal, 16)
}
