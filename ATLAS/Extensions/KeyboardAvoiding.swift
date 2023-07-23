//
//  KeyboardAvoiding.swift
//  ATLAS
//
//  Created by phuong phan on 09/06/2023.
//

import Foundation
import SwiftUI
import Combine

extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    private static weak var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }

    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}

public extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

public extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

public struct KeyboardAvoiding: ViewModifier {
    @State private var keyboardActiveAdjustment: CGFloat = 0

    public func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, spacing: keyboardActiveAdjustment) {
                EmptyView().frame(height: 0)
            }
            .onReceive(Publishers.keyboardHeight) {
                if $0.native == 0 {
                    self.keyboardActiveAdjustment = min($0, 0)
                } else {
                    self.keyboardActiveAdjustment = max($0, 580)
                }
            }
            .scrollDismissesKeyboard(.immediately)
    }
}

// Handle for modal sheet
struct KeyboardAdaptive: ViewModifier {
    @State private var height: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            withAnimation(.easeInOut(duration: 0.16)) {
                content
                    .presentationDetents([.height(height)])
                    .padding(.bottom, height > 0 ? 16 : 0)
                    .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                        self.height = keyboardHeight > 0 ? geometry.frame(in: .global).height - 60 - keyboardHeight : 0
                }
            }
        }
    }
}

struct KeyboardAvoidView: ViewModifier {
    @State private var keyboardActiveAdjustment: CGFloat = 0

    public func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, spacing: keyboardActiveAdjustment) {
                EmptyView().frame(height: 0)
            }
            .onReceive(Publishers.keyboardHeight) {
                if $0.native == 0 {
                    self.keyboardActiveAdjustment = min($0, 0)
                } else {
                    self.keyboardActiveAdjustment = max($0, 450)
                }
            }
            .scrollDismissesKeyboard(.immediately)
    }
}

public extension View {
    func keyboardAvoiding() -> some View {
        modifier(KeyboardAvoiding())
    }
    
    func keyboardAdaptive() -> some View {
        modifier(KeyboardAdaptive())
    }
    
    func keyboardAvoidView() -> some View {
        modifier(KeyboardAvoidView())
    }
}
