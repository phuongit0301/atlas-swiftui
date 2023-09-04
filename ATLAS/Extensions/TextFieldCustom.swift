//
//  TextFieldCustom.swift
//  ATLAS
//
//  Created by phuong phan on 23/07/2023.
//

import SwiftUI
import Foundation

extension UITextField {

    static var textDidBeginEditingNotificationPublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)
    }

    static var textDidEndEditingNotificationPublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)
    }

    static var textDidChangeNotificationPublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)
    }
}

struct ReturnKeyAutomaticallyEnable: ViewModifier {

    var enable: Bool

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(
                UITextField.textDidBeginEditingNotificationPublisher,
                perform: { ($0.object as? UITextField)?.enablesReturnKeyAutomatically = enable }
            )
    }
}


public extension View {
    func returnKeyAutomaticallyEnable(enable: Bool) -> some View {
        modifier(ReturnKeyAutomaticallyEnable(enable: enable))
   }
}
