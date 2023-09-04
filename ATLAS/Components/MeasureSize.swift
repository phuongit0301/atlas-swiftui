//
//  MeasureSize.swift
//  ATLAS
//
//  Created by phuong phan on 07/06/2023.
//

import Foundation

import Foundation
import SwiftUI
//
//private struct MeasuredSizePreferenceKey: PreferenceKey {
//    static var defaultValue: CGSize = .zero
//
//    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
//        value = nextValue()
//    }
//}
//
//private struct MeasureSizeModifier: ViewModifier {
//    private var measuringBackground: some View {
//        GeometryReader { geo in
//            Color.clear
//                .frame(width: 1, height: 1)
//                .preference(key: MeasuredSizePreferenceKey.self, value: geo.frame(in: .local).size)
//        }
//    }
//
//    func body(content: Content) -> some View {
//        return content
//            .background(measuringBackground)
//    }
//}
//
//
//public extension View {
//    /// Measures size of a given view.
//    /// - Parameters:
//    ///     - measureBlock: Block invoked after the size has been measured
//    func measureSize(_ measureBlock: @escaping (CGSize) -> Void) -> some View {
//        return modifier(MeasureSizeModifier())
//            .onPreferenceChange(MeasuredSizePreferenceKey.self) { measureBlock($0) }
//    }
//}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

struct MeasureSizeModifier: ViewModifier {
  func body(content: Content) -> some View {
    content.background(GeometryReader { geometry in
      Color.clear.preference(key: SizePreferenceKey.self,
                             value: geometry.size)
    })
  }
}

extension View {
  func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
    self.modifier(MeasureSizeModifier())
      .onPreferenceChange(SizePreferenceKey.self, perform: action)
  }
}
