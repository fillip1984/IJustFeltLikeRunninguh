//
//  DurationViewModifier.swift
//  IJustFeltLikeRunninguh
//
//  Created by Phillip Williams on 9/17/23.
//

import Combine
import SwiftUI

struct DurationViewModifier: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        content
            .keyboardType(.numberPad)
            .onReceive(Just(text)) { newValue in
                let numbers = "0123456789"

                // filter out all non-digits, limit to 6 places
                var finalValue = newValue.filter { numbers.contains($0) }.prefix(6)

                // format to have 00:00:00 structure progressively, meaning only add colons every space it should be to represent time
                switch finalValue.count {
                    // you could add this but then you'd have to remove leading zeros so I didn't bother
                    // case 1:
                    // finalValue = ":0" + finalValue
                    case 2:
                        finalValue.insert(":", at: finalValue.index(finalValue.startIndex, offsetBy: 0))
                    case 3:
                        finalValue.insert(":", at: finalValue.index(finalValue.startIndex, offsetBy: 1))
                    case 4:
                        finalValue.insert(":", at: finalValue.index(finalValue.startIndex, offsetBy: 2))
                    case 5:
                        finalValue.insert(":", at: finalValue.index(finalValue.startIndex, offsetBy: 1))
                        finalValue.insert(":", at: finalValue.index(finalValue.startIndex, offsetBy: 4))
                    case 6:
                        finalValue.insert(":", at: finalValue.index(finalValue.startIndex, offsetBy: 2))
                        finalValue.insert(":", at: finalValue.index(finalValue.startIndex, offsetBy: 5))
                    default:
                        // how to get switch must be exhaustive off my back!
                        finalValue = finalValue + ""
                }

                self.text = String(finalValue)
            }
    }
}

extension View {
    func durationInput(_ text: Binding<String>) -> some View {
        modifier(DurationViewModifier(text: text))
    }
}
