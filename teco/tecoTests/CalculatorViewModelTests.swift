//
//  CalculatorViewModelTests.swift
//  teco
//
//  Created by sun on 4/21/26.
//

import XCTest
@testable import teco

final class CalculatorViewModelTests: XCTestCase {

    private var viewModel: CalculatorViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CalculatorViewModel(logic: CalculatorLogic())
    }

    func testAdditionFlow() {
        viewModel.tap(.digit(7))
        viewModel.tap(.add)
        viewModel.tap(.digit(8))
        viewModel.tap(.equals)

        XCTAssertEqual(viewModel.displayText, "15")
    }

    func testClear() {
        viewModel.tap(.digit(9))
        viewModel.tap(.clear)

        XCTAssertEqual(viewModel.displayText, "0")
    }
}
