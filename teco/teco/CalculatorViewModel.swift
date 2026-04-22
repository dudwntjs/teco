//
//  CalculatorViewModel.swift
//  teco
//
//  Created by sun on 4/20/26.
//

import Foundation
import Combine

final class CalculatorViewModel: ObservableObject {
    @Published private(set) var displayText: String = "0"

    private let logic: CalculatorLogic

    private var currentInput: String = "0"
    private var storedValue: Decimal?
    private var pendingOperation: CalculatorOperation?
    private var isTypingNewNumber = false
    private var didTapEquals = false

    init(logic: CalculatorLogic = CalculatorLogic()) {
        self.logic = logic
    }

    func tap(_ button: CalculatorButton) {
        switch button {
        case .digit(let number):
            inputDigit(number)

        case .decimal:
            inputDecimal()

        case .add:
            setOperation(.add)

        case .subtract:
            setOperation(.subtract)

        case .multiply:
            setOperation(.multiply)

        case .divide:
            setOperation(.divide)

        case .equals:
            performEquals()

        case .percent:
            applyPercent()

        case .plusMinus:
            applyPlusMinus()

        case .clear:
            clearAll()

        case .backspace:
            backspace()
        }
    }
}

// MARK: - Private
private extension CalculatorViewModel {
    func inputDigit(_ digit: Int) {
        if didTapEquals {
            resetForNewCalculation()
        }

        if isTypingNewNumber {
            if currentInput == "0" {
                currentInput = "\(digit)"
            } else {
                currentInput += "\(digit)"
            }
        } else {
            currentInput = "\(digit)"
            isTypingNewNumber = true
        }

        updateDisplay()
    }

    func inputDecimal() {
        if didTapEquals {
            resetForNewCalculation()
        }

        if !isTypingNewNumber {
            currentInput = "0."
            isTypingNewNumber = true
        } else if !currentInput.contains(".") {
            currentInput += "."
        }

        updateDisplay()
    }

    func setOperation(_ operation: CalculatorOperation) {
        if let currentValue = logic.decimal(from: currentInput) {
            if let storedValue, let pendingOperation, isTypingNewNumber {
                if let result = logic.calculate(lhs: storedValue, rhs: currentValue, operation: pendingOperation) {
                    self.storedValue = result
                    currentInput = logic.string(from: result)
                } else {
                    showError()
                    return
                }
            } else {
                storedValue = currentValue
            }
        }

        pendingOperation = operation
        isTypingNewNumber = false
        didTapEquals = false
        updateDisplay()
    }

    func performEquals() {
        guard
            let operation = pendingOperation,
            let lhs = storedValue,
            let rhs = logic.decimal(from: currentInput)
        else { return }

        guard let result = logic.calculate(lhs: lhs, rhs: rhs, operation: operation) else {
            showError()
            return
        }

        currentInput = logic.string(from: result)
        storedValue = nil
        pendingOperation = nil
        isTypingNewNumber = false
        didTapEquals = true
        updateDisplay()
    }

    func applyPercent() {
        guard let value = logic.decimal(from: currentInput) else { return }
        let result = logic.percent(of: value)
        currentInput = logic.string(from: result)
        updateDisplay()
    }

    func applyPlusMinus() {
        guard let value = logic.decimal(from: currentInput) else { return }
        let result = logic.toggleSign(of: value)
        currentInput = logic.string(from: result)
        updateDisplay()
    }

    func backspace() {
        guard isTypingNewNumber || currentInput.count > 1 else {
            currentInput = "0"
            updateDisplay()
            return
        }

        if currentInput.count > 1 {
            currentInput.removeLast()
            if currentInput == "-" {
                currentInput = "0"
            }
        } else {
            currentInput = "0"
        }

        updateDisplay()
    }

    func clearAll() {
        currentInput = "0"
        storedValue = nil
        pendingOperation = nil
        isTypingNewNumber = false
        didTapEquals = false
        updateDisplay()
    }

    func showError() {
        displayText = "Error"
        currentInput = "0"
        storedValue = nil
        pendingOperation = nil
        isTypingNewNumber = false
        didTapEquals = false
    }

    func updateDisplay() {
        if let decimal = logic.decimal(from: currentInput) {
            if currentInput.hasSuffix(".") {
                let formatted = logic.string(from: decimal)
                displayText = formatted + "."
            } else {
                displayText = logic.string(from: decimal)
            }
        } else {
            displayText = currentInput
        }
    }

    func resetForNewCalculation() {
        currentInput = "0"
        storedValue = nil
        pendingOperation = nil
        isTypingNewNumber = false
        didTapEquals = false
    }
}
