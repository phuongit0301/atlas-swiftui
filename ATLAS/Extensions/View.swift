//
//  View.swift
//  ATLAS
//
//  Created by phuong phan on 24/05/2023.
//

import Foundation
import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
    
    func Print(_ item: Any) -> some View {
        #if DEBUG
        print(item)
        #endif
        return self
    }
}

struct TypeWriterText: View, Animatable {
    var string: String
    var count = 0

    var animatableData: Double {
        get { Double(count) }
        set { count = Int(max(0, newValue)) }
    }

    var body: some View {
        let stringToShow = String(string.prefix(count))
        ScrollView {
            Text(stringToShow).font(.custom("Inter-Regular", size: 16))
                .foregroundColor(Color.theme.eerieBlack)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
        }.frame(maxWidth: .infinity, maxHeight: 200)
    }
}

enum APIError: LocalizedError {
  /// Invalid request, e.g. invalid URL
  case invalidRequestError(String)
}
