//
//  PresentationDetentReference.swift
//  ATLAS
//
//  Created by phuong phan on 26/05/2023.
//

#if os(iOS)
import SwiftUI

/**
 This enum is used to bridge the SwiftUI `PresentationDetent`
 with UIKit `UISheetPresentationController.Detent.Identifier`.
 */
@available(iOS 16.0, *)
public enum PresentationDetentReference: Hashable {

    /// The system detent for a sheet at full height.
    case large

    /// The system detent for a sheet that's approximately half the available screen height.
    case medium

    /// A custom detent with the specified fractional height.
    case fraction(_ value: CGFloat)

    ///  A custom detent with the specified height.
    case height(_ value: CGFloat)

    var swiftUIDetent: PresentationDetent {
        switch self {
        case .large: return .large
        case .medium: return .medium
        case .fraction(let value): return .fraction(value)
        case .height(let value): return .height(value)
        }
    }

    var uiKitIdentifier: UISheetPresentationController.Detent.Identifier {
        switch self {
        case .large: return .large
        case .medium: return .medium
        case .fraction(let value): return .fraction(value)
        case .height(let value): return .height(value)
        }
    }
}

@available(iOS 16.0, *)
extension Collection where Element == PresentationDetentReference {

    var swiftUISet: Set<PresentationDetent> {
        Set(map { $0.swiftUIDetent })
    }
}

@available(iOS 16.0, *)
public extension UISheetPresentationController.Detent.Identifier {

    /// A fraction-specific detent identifier.
    static func fraction(_ value: CGFloat) -> Self {
        .init("Fraction:\(String(format: "%.1f", value))")
    }

    /// A height-specific detent identifier.
    static func height(_ value: CGFloat) -> Self {
        .init("Height:\(value)")
    }
}
#endif
