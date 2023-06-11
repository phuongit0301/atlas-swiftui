//
//  KeyboardAvoiding.swift
//  ATLAS
//
//  Created by phuong phan on 09/06/2023.
//

import Foundation
import SwiftUI
import Combine

//extension UIResponder {
//    static var currentFirstResponder: UIResponder? {
//        _currentFirstResponder = nil
//        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
//        return _currentFirstResponder
//    }
//
//    private static weak var _currentFirstResponder: UIResponder?
//
//    @objc private func findFirstResponder(_ sender: Any) {
//        UIResponder._currentFirstResponder = self
//    }
//
//    var globalFrame: CGRect? {
//        guard let view = self as? UIView else { return nil }
//        return view.superview?.convert(view.frame, to: nil)
//    }
//}
//
//extension Publishers {
//    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
//        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
//            .map { $0.keyboardHeight }
//
//        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
//            .map { _ in CGFloat(0) }
//
//        return MergeMany(willShow, willHide)
//            .eraseToAnyPublisher()
//    }
//}
//
//extension Notification {
//    var keyboardHeight: CGFloat {
//        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
//    }
//}
//
///// Note that the `KeyboardAdaptive` modifier wraps your view in a `GeometryReader`,
///// which attempts to fill all the available space, potentially increasing content view size.
//struct KeyboardAdaptive: ViewModifier {
//    @State private var bottomPadding: CGFloat = 0
//
//    func body(content: Content) -> some View {
//        GeometryReader { geometry in
//            withAnimation(.easeInOut(duration: 0.16)) {
//                content
//                    .padding(.bottom, self.bottomPadding)
//                    .onReceive(Publishers.keyboardHeight) { keyboardHeight in
//                        let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
//                        let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
//                        self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
//                }
//            }
//        }
//    }
//}
//
//extension View {
//    func keyboardAdaptive() -> some View {
//        ModifiedContent(content: self, modifier: KeyboardAdaptive())
//    }
//}


struct AdaptsToSoftwareKeyboard: ViewModifier {
  @State var currentHeight: CGFloat = 0

  func body(content: Content) -> some View {
    content
      .padding(.bottom, currentHeight)
//      .edgesIgnoringSafeArea(.bottom)
      .edgesIgnoringSafeArea(currentHeight == 0 ? [] : .bottom)
      .onAppear(perform: subscribeToKeyboardEvents)
  }

  private func subscribeToKeyboardEvents() {
    NotificationCenter.Publisher(
      center: NotificationCenter.default,
      name: UIResponder.keyboardWillShowNotification
    ).compactMap { notification in
        notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
    }.map { rect in
      rect.height
    }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))

    NotificationCenter.Publisher(
      center: NotificationCenter.default,
      name: UIResponder.keyboardWillHideNotification
    ).compactMap { notification in
      CGFloat.zero
    }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
  }
}

extension Animation {
    static var keyboard: Animation {
        .interpolatingSpring(mass: 3, stiffness: 1000, damping: 500, initialVelocity: 0.0)
    }
}


//struct Keyboard: ViewModifier {
//    @State var offset: CGFloat = 0
//
//    func body(content: Content) -> some View {
//        content.padding(.bottom, offset).onAppear {
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
//                let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//                let height = value.height
//
//                self.offset = height + 200
//            }
//
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
//                self.offset = 0
//            }
//        }
//    }
//}
