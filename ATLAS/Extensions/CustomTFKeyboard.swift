//
//  CustomTFKeyboard.swift
//  ATLAS
//
//  Created by phuong phan on 05/07/2023.
//

import SwiftUI

extension TextField {
    @ViewBuilder
    func inputView<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        self.background {
            SetTFKeyboard(keyboardContent: content())
        }
    }
}

fileprivate struct SetTFKeyboard<Content: View>: UIViewRepresentable {
    var keyboardContent: Content
    @State private var hostingController: UIHostingController<Content>?
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let textFieldContainerView = uiView.superview?.superview {
                if let textField = textFieldContainerView.findTextField {
                    // If the input is already set, then updating it's content
                    if textField.inputView == nil {
                        // Now with the help of UIHosting Controller converting SwiftUI View into UIKit View
                        hostingController = UIHostingController(rootView: keyboardContent)
                        hostingController?.view.frame = .init(origin: .zero, size: hostingController?.view.intrinsicContentSize ?? .zero)
                        textField.inputView = hostingController?.view
                    } else {
                        hostingController?.rootView = keyboardContent
                    }
                } else {
                    print("Failed to Find TF")
                }
            }
        }
    }
}

fileprivate extension UIView {
    var allSubViews: [UIView] {
        return subviews.flatMap { [$0] + $0.subviews }
    }
    
    // Finding the UIView is TextField or not
    var findTextField: UITextField? {
        if let textField = allSubViews.first(where: { view in
            view is UITextField
        }) as? UITextField {
            return textField
        }
        
        return nil
    }
}
