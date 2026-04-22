//
//  CalculatorLogicTests.swift
//  teco
//
//  Created by sun on 4/21/26.
//

import XCTest
@testable import teco

final class CalculatorLogicTests: XCTestCase {

    private var logic: CalculatorLogic!

    override func setUp() {
        super.setUp()
        logic = CalculatorLogic()
    }

    func testAddition() {
        let result = logic.calculate(lhs: 10, rhs: 5, operation: .add)
        XCTAssertEqual(result, 15)
    }

    func testDivisionByZeroReturnsNil() {
        let result = logic.calculate(lhs: 10, rhs: 0, operation: .divide)
        XCTAssertNil(result)
    }
}
