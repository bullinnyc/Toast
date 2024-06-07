//
//  ToastTests.swift
//  ToastTests
//
//  Created by Dmitry Kononchuk on 04.06.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import XCTest
@testable import Toast

final class ToastTests: XCTestCase {
    var sut: Sut!
    
    override func setUp() {
        super.setUp()
        
        sut = makeSUT()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func testShow() {
        // Given
        let toast: Toast = sut
        let title = "Foo"
        let message = "Bar"
        let image = RM.image("mars")
        let style: ToastStyle = .space
        let duration: TimeInterval = 0.3
        let deadline: Double = 4
        
        var isShowToastCompletionCalled = false
        
        // When
        let expectation = XCTestExpectation(description: "Show toast")
        
        toast.show(
            title: title,
            message: message,
            image: image,
            style: style,
            duration: duration,
            deadline: deadline,
            completion: { isShowToast in
                isShowToastCompletionCalled = isShowToast
                expectation.fulfill()
            }
        )
        
        // Then
        XCTAssertTrue(toast.isShowToast, "Toast should be true.")
        
        XCTAssertEqual(
            toast.toast.title,
            title,
            "Toast title should be equal."
        )
        
        XCTAssertEqual(
            toast.toast.message,
            message,
            "Toast message should be equal."
        )
        
        XCTAssertEqual(
            toast.toast.image,
            image,
            "Toast image should be equal."
        )
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(
            isShowToastCompletionCalled,
            "Completion called should be true."
        )
    }
}

extension ToastTests {
    typealias Sut = Toast
    
    private func makeSUT() -> Sut {
        Toast()
    }
}
