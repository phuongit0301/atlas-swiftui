import SwiftUI
import Combine

struct CustomKeyboardView1: View {
    @Binding var text: String
    @Binding var cursorPosition: Int
    @Binding var currentFocus: Bool
    @Binding var nextFocus: Bool
    @Binding var prevFocus: Bool

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
        ["Z", "SP", "⌫", "return", "keyboard.chevron.compact.down.fill"]
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
                                if character == "keyboard.chevron.compact.down.fill" || character == "return" {
                                    VStack {
                                        Image(systemName: character).foregroundColor(Color.white)
                                    }.frame(width: 50, height: 50)
                                        .background(Color.gray)
                                        .cornerRadius(8)
                                } else {
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
    }

    private func handleInput(_ character: String) {
        if character == "return" {
            if nextFocus {
                submit()
            } else {
                currentFocus = false
            }
        } else if character == "keyboard.chevron.compact.down.fill" {
            currentFocus = false
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
        ["Z", "SP", "⌫", "return", "keyboard.chevron.compact.down.fill"]
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
        if character == "return" {
            submit()
        } else if character == "keyboard.chevron.compact.down.fill" {
            currentFocus = false
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
struct customKeyboardTestView: View {
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""
    @State private var isEditing1 = false
    @State private var isEditing2 = false
    @State private var isEditing3 = false
    @State private var cursorPosition1 = 0
    @State private var cursorPosition2 = 0
    @State private var cursorPosition3 = 0
    @State private var isTextField1Focused = false
    @State private var isTextField2Focused = false
    @State private var isTextField3Focused = false
    
    @FocusState private var isHiddenKeyboard1: Bool
    @FocusState private var isHiddenKeyboard2: Bool
    @FocusState private var isHiddenKeyboard3: Bool
    
    @State private var isShowingAutofillOptions1 = false
    @State private var isShowingAutofillOptions2 = false
    @State private var isShowingAutofillOptions3 = false

    @State private var autofillOptions: [String] = ["APPLE", "BANANA", "CHERRY", "BLUEBERRY"] // Replace with your own autofill options
    @State private var autofillText1 = ""
    @State private var autofillText2 = ""
    @State private var autofillText3 = ""

    var body: some View {
        VStack {
            TextField("Enter text1", text: $text1)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .focused($isHiddenKeyboard1)
            .onReceive(Just(text1)) { text in
                let components = text.components(separatedBy: " ")
                if let lastComponent = components.last, lastComponent.hasPrefix(".") && lastComponent.count > 1 {
                    let searchTerm = String(lastComponent.dropFirst())
                    autofillText1 = searchTerm
                    isShowingAutofillOptions1 = true
                } else {
                    isShowingAutofillOptions1 = false
                }
            }
            .onReceive(Just(isTextField1Focused)) { focused in
                if !focused {
                    isShowingAutofillOptions1 = false
                    isEditing1 = false
                }
                else {
                    isEditing1 = true
                }
            }
            .onReceive(Just(isHiddenKeyboard1)) { focused in
                if focused {
                    isHiddenKeyboard1 = false
                    isEditing1 = true
                    isTextField1Focused = true
                    isTextField2Focused = false
                    isTextField3Focused = false
                }
            }
        
            if isEditing1 {
                CustomKeyboardView1(text: $text1, cursorPosition: $cursorPosition1, currentFocus: $isTextField1Focused, nextFocus: $isTextField2Focused, prevFocus: $isTextField3Focused)
            }
            if isShowingAutofillOptions1 {
                List(autofillOptions.filter { $0.hasPrefix(autofillText1) }, id: \.self) { option in
                    Button(action: {
                        let modifiedText = text1.components(separatedBy: " ").dropLast().joined(separator: " ")
                        cursorPosition1 -= text1.count
                        text1 = modifiedText + " " + option + " "
                        cursorPosition1 += text1.count
                        isShowingAutofillOptions1 = false
                    }) {
                        Text(option)
                    }
                }
                .listStyle(GroupedListStyle())
            }
            
            TextField("Enter text2", text: $text2)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .focused($isHiddenKeyboard2)
            .onReceive(Just(text2)) { text in
                let components = text.components(separatedBy: " ")
                if let lastComponent = components.last, lastComponent.hasPrefix(".") && lastComponent.count > 1 {
                    let searchTerm = String(lastComponent.dropFirst())
                    autofillText2 = searchTerm
                    isShowingAutofillOptions2 = true
                } else {
                    isShowingAutofillOptions2 = false
                }
            }
            .onReceive(Just(isTextField2Focused)) { focused in
                if !focused {
                    isShowingAutofillOptions2 = false
                    isEditing2 = false
                }
                else {
                    isEditing2 = true
                }
            }
            .onReceive(Just(isHiddenKeyboard2)) { focused in
                if focused {
                    isHiddenKeyboard2 = false
                    isEditing2 = true
                    isTextField2Focused = true
                    isTextField1Focused = false
                    isTextField3Focused = false
                }
            }
            if isEditing2 {
                CustomKeyboardView1(text: $text2, cursorPosition: $cursorPosition2, currentFocus: $isTextField2Focused, nextFocus: $isTextField3Focused, prevFocus: $isTextField1Focused)
            }
            if isShowingAutofillOptions2 {
                List(autofillOptions.filter { $0.hasPrefix(autofillText2) }, id: \.self) { option in
                    Button(action: {
                        let modifiedText = text2.components(separatedBy: " ").dropLast().joined(separator: " ")
                        cursorPosition2 -= text2.count
                        text2 = modifiedText + " " + option + " "
                        cursorPosition2 += text2.count
                        isShowingAutofillOptions2 = false
                    }) {
                        Text(option)
                    }
                }
                .listStyle(GroupedListStyle())
            }
            
            TextField("Enter text3", text: $text3)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .focused($isHiddenKeyboard3)
            .onReceive(Just(text3)) { text in
                let components = text.components(separatedBy: " ")
                if let lastComponent = components.last, lastComponent.hasPrefix(".") && lastComponent.count > 1 {
                    let searchTerm = String(lastComponent.dropFirst())
                    autofillText3 = searchTerm
                    isShowingAutofillOptions3 = true
                } else {
                    isShowingAutofillOptions3 = false
                }
            }
            .onReceive(Just(isTextField3Focused)) { focused in
                if !focused {
                    isShowingAutofillOptions3 = false
                    isEditing3 = false
                }
                else {
                    isEditing3 = true
                }
            }
            .onReceive(Just(isHiddenKeyboard3)) { focused in
                if focused {
                    isHiddenKeyboard3 = false
                    isEditing3 = true
                    isTextField3Focused = true
                    isTextField1Focused = false
                    isTextField2Focused = false
                }
            }
            if isEditing3 {
                CustomKeyboardView1(text: $text3, cursorPosition: $cursorPosition3, currentFocus: $isTextField3Focused, nextFocus: $isTextField1Focused, prevFocus: $isTextField2Focused)
            }
            if isShowingAutofillOptions3 {
                List(autofillOptions.filter { $0.hasPrefix(autofillText3) }, id: \.self) { option in
                    Button(action: {
                        let modifiedText = text3.components(separatedBy: " ").dropLast().joined(separator: " ")
                        cursorPosition3 -= text3.count
                        text3 = modifiedText + " " + option + " "
                        cursorPosition3 += text3.count
                        isShowingAutofillOptions3 = false
                    }) {
                        Text(option)
                    }
                }
                .listStyle(GroupedListStyle())
            }
        }
        
    }
}
