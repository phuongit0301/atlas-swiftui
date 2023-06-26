import SwiftUI

struct CustomKeyboardView: View {
    @Binding var text: String
    @Binding var cursorPosition: Int
    @FocusState var currentFocus: Bool
    @FocusState var nextFocus: Bool
    @FocusState var prevFocus: Bool

    let numeric: [[String]] = [
        ["", "", ""],
        ["←", "→", "/"],
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "-"],
    ]
    
    let alpha: [[String]] = [
        ["A", "B", "C", "D", "E"],
        ["F", "G", "H", "I", "J"],
        ["K", "L", "M", "N", "O"],
        ["P", "Q", "R", "S", "T"],
        ["U", "V", "W", "X", "Y"],
        ["Z", "/", "SP", "⌫", "EXEC"]
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
        if character == "EXEC" {
            submit()
        }
        else if character == "SP" {
            insertCharacter(" ")
        }
        else if character == "←" {
            moveBackward()
        } else if character == "→" {
            moveForward()
        } else if character == "⌫" {
            deletePreviousCharacter()
        } else {
            insertCharacter(character)
            moveCursorForward()
        }
    }

    private func submit() {
        currentFocus = false
        nextFocus = true
    }
    
    private func insertCharacter(_ character: String) {
        let start = text.index(text.startIndex, offsetBy: cursorPosition)
        text.insert(contentsOf: character, at: start)
        moveCursorForward()
    }

    private func moveBackward() {
        currentFocus = false
        prevFocus = true
    }

    private func moveForward() {
        submit()
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
}
