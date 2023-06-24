//
//  customKeyboard.swift
//  ATLAS
//
//  Created by Muhammad Adil on 24/6/23.
//

import Foundation
import SwiftUI

struct CustomKeyboardView: View {
    @Binding var text: String
    @Binding var cursorPosition: Int

    let numeric: [[String]] = [
        ["", "", ""],
        ["←", "→", " "],
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["0", ".", ""],
    ]
    
    let alpha: [[String]] = [
        ["A", "B", "C", "D", "E"],
        ["F", "G", "H", "I", "J"],
        ["K", "L", "M", "N", "O"],
        ["P", "Q", "R", "S", "T"],
        ["U", "V", "W", "X", "Y"],
        ["Z", "SP", "⌫", "/", ""]
    ]

    var body: some View {
        HStack(spacing:10) {
            VStack(spacing: 10) {
                ForEach(numeric, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(row, id: \.self) { character in
                            Button(action: {
                                handleInput(character)
                            }) {
                                Text(character)
                                    .font(.title)
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray)
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding(.trailing, 10)
            VStack(spacing: 10) {
                ForEach(alpha, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(row, id: \.self) { character in
                            Button(action: {
                                handleInput(character)
                            }) {
                                Text(character)
                                    .font(.title)
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray)
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
    }

    private func handleInput(_ character: String) {
        if character == "SP" {
            insertCharacter(" ")
        }
        else if character == "←" {
            moveCursorBackward()
        } else if character == "→" {
            moveCursorForward()
        } else if character == "⌫" {
            deletePreviousCharacter()
        } else {
            insertCharacter(character)
            moveCursorForward()
        }
    }

    private func insertCharacter(_ character: String) {
        let start = text.index(text.startIndex, offsetBy: cursorPosition)
        text.insert(contentsOf: character, at: start)
    }

    private func moveCursorBackward() {
        if cursorPosition > 0 {
            cursorPosition -= 1
        }
    }

    private func moveCursorForward() {
        if cursorPosition < text.count {
            cursorPosition += 1
        }
    }

    private func deletePreviousCharacter() {
        guard cursorPosition > 0 && cursorPosition <= text.count else {
            return
        }

        let start = text.index(text.startIndex, offsetBy: cursorPosition - 1)
        text.remove(at: start)
        cursorPosition -= 1
    }
    
    // Property observer to update cursorPosition when text changes
    private var textBinding: Binding<String> {
        Binding<String>(
            get: { self.text },
            set: {
                self.text = $0
                self.cursorPosition = $0.count
            }
        )
    }
}

// to use:
struct testKeyboardContentView: View {
    @State private var text = ""
    @State private var isEditing = false
    @State private var cursorPosition = 0

    var body: some View {
        VStack {
            TextField("Enter text", text: $text, onEditingChanged: { editing in
                isEditing = editing
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { _ in
                    cursorPosition = text.count
                }
            if isEditing {
                CustomKeyboardView(text: $text, cursorPosition: $cursorPosition)
            }
        }
        .onAppear {
            cursorPosition = text.count // Set the initial cursor position to the end of the text
        }
    }
}
