//
//  Toast.swift
//  Toast
//
//  Created by Dmitry Kononchuk on 10.05.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

/// Toast.
public final class Toast: ObservableObject {
    // MARK: - Property Wrappers
    
    @Published private(set) var isShowToast = false
    @Published private(set) var toastHeight: CGFloat = .zero
    @Published private(set) var titleHeight: CGFloat = .zero
    @Published private(set) var messageHeight: CGFloat = .zero
    
    // MARK: - Private Properties
    
    private(set) var toast: ToastMessage!
    private(set) var style: ToastStyle!
    
    private var duration: TimeInterval!
    private var completion: ((_ isShowToast: Bool) -> Void)?
    
    private var window: UIWindow?
    
    private var showTasks: [DispatchWorkItem] = []
    private var hideTask: DispatchWorkItem?
    
    // MARK: - Initializers
    
    public init() {}
    
    // MARK: - Deinitializers
    
    deinit {
        window = nil
    }
    
    // MARK: - Public Methods
    
    /// Show toast.
    ///
    /// - Parameters:
    ///   - title: Title to be displayed.
    ///   - message: Message to be displayed.
    ///   - image: Image to be displayed.
    ///   - style: Toast style.
    ///   - duration: The total duration of the animations, measured in seconds.
    ///   - deadline: The toast display deadline, measured in seconds.
    ///   - completion: A block object to be executed when the animation sequence ends.
    public func show(
        title: String? = nil,
        message: String,
        image: UIImage? = nil,
        style: ToastStyle = .space,
        duration: TimeInterval = 0.3,
        deadline: Double = 4,
        completion: ((_ isShowToast: Bool) -> Void)? = nil
    ) {
        if isShowToast {
            let showTask = DispatchWorkItem { [weak self] in
                self?.show(
                    title: title,
                    message: message,
                    image: image,
                    style: style,
                    duration: duration,
                    deadline: deadline,
                    completion: completion
                )
            }
            
            showTasks.append(showTask)
            return
        }
        
        prepareWindow()
        
        self.style = style
        self.duration = duration
        self.completion = completion
        
        calculateAndSetHeight(title: title, message: message, image: image)
        window?.frame = getFrame(isHiddenToast: true)
        setToast(title: title, message: message, image: image, isShow: true)
        
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                guard let self = self else { return }
                self.window?.frame = self.getFrame(isHiddenToast: false)
            }
        ) { [weak self] _ in
            guard let self = self else { return }
            
            self.updateTask(deadline)
            self.completion?(self.isShowToast)
        }
    }
    
    /// Cancel next toasts.
    public func cancelNextToasts() {
        showTasks.forEach { $0.cancel() }
        showTasks.removeAll()
    }
    
    /// Cancel all toasts.
    public func cancelAllToasts() {
        cancelNextToasts()
        cancelHideTask()
        setToast(title: nil, message: "", image: nil, isShow: false)
        window = nil
    }
    
    // MARK: - Private Methods
    
    private func prepareWindow() {
        guard window == nil, let scene = UIWindow.scene else { return }
        
        let view = ToastView(
            onRotate: { [weak self] isFinishTransition in
                self?.transitionAnimation(isFinishTransition)
            },
            onHide: { [weak self] in
                self?.hide()
            }
        ).environmentObject(self)
        
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.backgroundColor = .clear
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    private func hide() {
        cancelHideTask()
        
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                guard let self = self else { return }
                self.window?.frame = self.getFrame(isHiddenToast: true)
            }
        ) { [weak self] _ in
            guard let self = self else { return }
            
            self.setToast(title: nil, message: "", image: nil, isShow: false)
            self.completion?(self.isShowToast)
            
            self.window = nil
            self.performNextShowTask()
        }
    }
    
    func transitionAnimation(_ isFinishTransition: Bool) {
        guard isShowToast else { return }
        
        if isFinishTransition {
            calculateAndSetHeight(
                title: toast.title,
                message: toast.message,
                image: toast.image
            )
            
            window?.isHidden = false
            
            UIView.animate(
                withDuration: duration,
                animations: { [weak self] in
                    guard let self = self else { return }
                    self.window?.frame = self.getFrame(isHiddenToast: false)
                }
            )
        } else {
            window?.isHidden = true
            window?.frame = getFrame(isHiddenToast: true)
        }
    }
    
    private func calculateAndSetHeight(
        title: String?,
        message: String,
        image: UIImage?
    ) {
        let spyText = "X"
        let verticalSpacing = title == nil ? .zero : ToastView.verticalSpacing
        
        let titleHeight = getTextHeight(
            with: title ?? title == "" ? spyText : title ?? "",
            image: image,
            lineLimit: style.titleLineLimit,
            alignment: style.titleTextAlignment.toHorizontalNSTextAlignment,
            font: style.titleFont
        )
        
        let messageHeight = getTextHeight(
            with: message.isEmpty ? spyText : message,
            image: image,
            lineLimit: style.messageLineLimit,
            alignment: style.messageTextAlignment.toHorizontalNSTextAlignment,
            font: style.messageFont
        )
        
        let modifyMessageHeight = modifyMessageHeight(
            messageHeight,
            spyText: spyText,
            image: image
        ) ?? messageHeight
        
        self.titleHeight = titleHeight
        self.messageHeight = modifyMessageHeight
        
        toastHeight = titleHeight + modifyMessageHeight + verticalSpacing +
            ToastView.topPadding + ToastView.bottomPadding
    }
    
    private func modifyMessageHeight(
        _ messageHeight: CGFloat,
        spyText: String,
        image: UIImage?
    ) -> CGFloat? {
        guard image != nil else { return nil }
        
        let spyTextHeight = getTextHeight(
            with: spyText,
            image: image,
            lineLimit: style.messageLineLimit,
            alignment: style.messageTextAlignment.toHorizontalNSTextAlignment,
            font: style.messageFont
        )
        
        if spyTextHeight == messageHeight {
            let textLine = 2
            return messageHeight * CGFloat(textLine)
        }
        
        return nil
    }
    
    private func getTextHeight(
        with text: String,
        image: UIImage?,
        lineLimit: Int,
        alignment: NSTextAlignment,
        font: UIFont
    ) -> CGFloat {
        let screenWidth = UIWindow.screenSize.width
        
        let width = image == nil
            ? screenWidth - ToastView.horizontalPadding * 2
            : screenWidth - ToastView.horizontalPadding - ToastView.sidePadding
        
        let widthWithHorizontalSafeArea = width -
            ToastView.safeAreaInsetsLeft - ToastView.safeAreaInsetsRight
        
        let textSize = text.getTextSize(
            numberOfLines: lineLimit,
            lineBreakMode: .byTruncatingTail,
            alignment: alignment,
            font: font,
            width: widthWithHorizontalSafeArea
        )
        
        return textSize.height
    }
    
    private func getFrame(isHiddenToast: Bool) -> CGRect {
        CGRect(
            x: .zero,
            y: isHiddenToast ? -toastHeight : .zero,
            width: UIWindow.screenSize.width,
            height: toastHeight
        )
    }
    
    private func setToast(
        title: String?,
        message: String,
        image: UIImage?,
        isShow: Bool
    ) {
        toast = ToastMessage(title: title, message: message, image: image)
        isShowToast = isShow
    }
    
    private func updateTask(_ deadline: Double) {
        cancelHideTask()
        
        guard deadline != .zero else { return }
        
        hideTask = DispatchWorkItem { [weak self] in
            self?.hide()
            self?.hideTask = nil
        }
        
        guard let hideTask = hideTask else { return }
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + deadline,
            execute: hideTask
        )
    }
    
    private func performNextShowTask() {
        guard let nextShowTask = showTasks.first else { return }
        
        showTasks.removeFirst()
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.2,
            execute: nextShowTask
        )
    }
    
    private func cancelHideTask() {
        guard let runningTask = hideTask else { return }
        
        runningTask.cancel()
        hideTask = nil
    }
}
