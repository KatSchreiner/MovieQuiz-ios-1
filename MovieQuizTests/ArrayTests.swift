//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Екатерина Шрайнер on 19.02.2024.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        // дано
        let array = [1, 1, 2, 3, 5]
        
        // когда
        let value = array[safe: 2]
        
        // тогда
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        // дано
        let array = [1, 1, 2, 3, 5]
        
        // когда
        let value = array[safe: 20]
        
        // тогда
        XCTAssertNil(value)
    }
}
