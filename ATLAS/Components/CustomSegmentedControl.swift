//
//  CustomSegment.swift
//  ATLAS
//
//  Created by phuong phan on 19/06/2023.
//

import Foundation
import SwiftUI

struct CustomTab<T: Equatable>  {
    var title: String
    var screenName: T
    
    static func ==(lhs: Self, rhs: T) -> Bool {
        lhs == rhs
    }
}

struct CustomSegmentedControl<SelectionValue>: View where SelectionValue: Hashable {
    @Binding var preselected: SelectionValue
    var options: [CustomTab<SelectionValue>]
    let geoWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                Text(options[index].title).font(.system(size: 17, weight:
                        .regular)).foregroundColor(preselected == options[index].screenName ? Color.theme.azure : Color.theme.spanishGray)
                    .onTapGesture {
                        withAnimation(.interactiveSpring()) {
                            preselected = options[index].screenName
                        }
                    }.frame(width: geoWidth / CGFloat(options.count))
            }
        }
        .frame(height: 65)
        .background(.white)
    }
}

enum FlightNoteEnumeration: CustomStringConvertible {
    case MapScreen
    case NoteScreen
    
    var description: String {
        switch self {
            case .MapScreen:
                return "Map"
            case .NoteScreen:
                return "Notes"
        }
    }
}

let IFlightNoteTabs = [
    CustomTab(title: "Map", screenName: FlightNoteEnumeration.MapScreen),
    CustomTab(title: "Notes", screenName: FlightNoteEnumeration.NoteScreen),
]
