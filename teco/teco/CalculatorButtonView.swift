//
//  CalculatorButtonView.swift
//  teco
//
//  Created by sun on 4/20/26.
//

import SwiftUI

struct CalculatorButtonView: View {
    let button: CalculatorButton
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(button.title)
                .font(.system(size: 34, weight: .regular))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(button.foregroundColor)
                .background(button.backgroundColor)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
