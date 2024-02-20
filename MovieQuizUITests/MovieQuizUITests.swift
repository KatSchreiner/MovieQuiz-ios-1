//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Екатерина Шрайнер on 19.02.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
                
        app.terminate()
        app = nil
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton() {
            sleep(3)
            
            let firstPoster = app.images["Poster"]
            let firstPosterData = firstPoster.screenshot().pngRepresentation
            
            app.buttons["No"].tap()
            sleep(3)
            
            let secondPoster = app.images["Poster"]
            let secondPosterData = secondPoster.screenshot().pngRepresentation
            
            let indexLabel = app.staticTexts["Index"]

            XCTAssertNotEqual(firstPosterData, secondPosterData)
            XCTAssertEqual(indexLabel.label, "2/10")
        }
    
    func testAlertResult() {
        sleep(1)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(1)
        }

        let alertResult = app.alerts["showAlert"]
        let title = alertResult.label
        let button = alertResult.buttons.firstMatch.label
        
        XCTAssertTrue(alertResult.exists)
        XCTAssertEqual(title, "Этот раунд окончен!")
        XCTAssertEqual(button, "Сыграть еще раз")
    }

    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["showAlert"]
        
        alert.buttons.firstMatch.tap()
        
                        
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
