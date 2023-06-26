import SwiftUI
import Combine

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
            //moveCursorForward()
        }
    }

    private func submit() {
        currentFocus = false
        nextFocus = true
    }
    
    private func insertCharacter(_ character: String) {
        currentFocus = true
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
        currentFocus = true
        guard cursorPosition > 0 && cursorPosition <= text.count else {
            return
        }

        let start = text.index(text.startIndex, offsetBy: cursorPosition - 1)
        text.remove(at: start)
        cursorPosition -= 1
    }
}

// to use:
struct testCustomKeyboardContentView: View {
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""
    @State private var isEditing1 = false
    @State private var isEditing2 = false
    @State private var isEditing3 = false
    @State private var cursorPosition1 = 0
    @State private var cursorPosition2 = 0
    @State private var cursorPosition3 = 0
    @FocusState private var isTextField1Focused: Bool
    @FocusState private var isTextField2Focused: Bool
    @FocusState private var isTextField3Focused: Bool
    
    @State private var isShowingAutofillOptions = false
    @State private var autofillOptions: [String] = ["APPLE", "BANANA", "CHERRY", "BLUEBERRY"] // Replace with your own autofill options
    @State private var autofillText = ""

    var body: some View {
        VStack {
            TextField("Enter text1", text: $text1, onEditingChanged: { editing in
                isEditing1 = editing
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .focused($isTextField1Focused)
            .onReceive(Just(text1)) { text in
                let components = text.components(separatedBy: " ")
                if let lastComponent = components.last, lastComponent.hasPrefix(".") && lastComponent.count > 1 {
                    let searchTerm = String(lastComponent.dropFirst())
                    autofillText = searchTerm
                    isShowingAutofillOptions = true
                } else {
                    isShowingAutofillOptions = false
                }
            }
            .onReceive(Just(isTextField1Focused)) { focused in
                if !focused {
                    isShowingAutofillOptions = false
                }
            }
        
            if isShowingAutofillOptions {
                List(autofillOptions.filter { $0.hasPrefix(autofillText) }, id: \.self) { option in
                    Button(action: {
                        let modifiedText = text1.components(separatedBy: " ").dropLast().joined(separator: " ")
                        cursorPosition1 -= text1.count
                        text1 = modifiedText + " " + option + " "
                        cursorPosition1 += text1.count
                        isShowingAutofillOptions = false
                    }) {
                        Text(option)
                    }
                }
                .listStyle(GroupedListStyle())
            }
            if isEditing1 {
                CustomKeyboardView(text: $text1, cursorPosition: $cursorPosition1, currentFocus: _isTextField1Focused, nextFocus: _isTextField2Focused, prevFocus: _isTextField3Focused)
            }
            TextField("Enter text2", text: $text2, onEditingChanged: { editing in
                isEditing2 = editing
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .focused($isTextField2Focused)
            if isEditing2 {
                CustomKeyboardView(text: $text2, cursorPosition: $cursorPosition2, currentFocus: _isTextField2Focused, nextFocus: _isTextField3Focused, prevFocus: _isTextField1Focused)
            }
            TextField("Enter text3", text: $text3, onEditingChanged: { editing in
                isEditing3 = editing
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .focused($isTextField3Focused)
            if isEditing3 {
                CustomKeyboardView(text: $text3, cursorPosition: $cursorPosition3, currentFocus: _isTextField3Focused, nextFocus: _isTextField1Focused, prevFocus: _isTextField2Focused)
            }
        }
        .onAppear {
            cursorPosition1 = text1.count // Set the initial cursor position to the end of the text
            cursorPosition2 = text2.count // Set the initial cursor position to the end of the text
        }
    }
}

