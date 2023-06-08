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
    
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
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
        }.frame(maxWidth: .infinity, maxHeight: 300)
    }
}
//
//class Paragrapher: ObservableObject {
//    //what is the full text when we are done?
//    //NOTE: this is stored as an array of Strings
//    //      that we will join element-by-element
//    //      when the time comes
//    let fullText: [String]
//    //how long between showing each element?
//    let delay: Double
//
//    //the text we display to the outside world
//    @Published var partialText = ""
//
//    //are we splitting the fullText by letters or words?
//    enum ParagraphSplit {
//        case letters
//        case words
//    }
//    private let splitBy: ParagraphSplit
//
//    //used when we rejoin our split text
//    private let separator: String
//
//    //how many elements have we shown so far
//    private var showTextCount = 0
//
//    //reference to our timer
//    private var timer = Timer()
//
//    var textComplete: Bool {
//        showTextCount == fullText.count
//    }
//
//    init(with fullText: String,
//         splitBy: ParagraphSplit = .letters,
//         delayedBy: Double = 0.2) {
//
//        //how do we want to split our fullText?
//        self.splitBy = splitBy
//
//        if splitBy == .letters {
//            //store each letter in our fullText array
//            self.fullText = fullText.map { String($0) }
//            //we want no separator between the letters
//            //when we rejoin
//            self.separator = ""
//        } else {
//            //store each word in our fullText array
//            self.fullText = fullText.components(separatedBy: .whitespaces)
//            //rejoin them with a space in between each word
//            self.separator = " "
//        }
//
//        //how long do we want to wait in between showing each element?
//        self.delay = delayedBy
//    }
//
//    //start displaying elements on our schedule
//    func start() {
//        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { [self] _ in
//            //every time the Timer fires...
//            //increment how many elements we are showing
//            showTextCount += 1
//            //create our partialText by joining the appropriate
//            //number of elements
//            partialText = fullText[0..<showTextCount].joined(separator: separator)
//            //if we've got all elements, stop the timer
//            if showTextCount == fullText.count {
//                self.stop()
//            }
//        }
//    }
//
//    //stop displaying elements
//    //use: clearText == false to later resume where we left off
//    //     clearText == true to start over again
//    func stop(clearText: Bool = false) {
//        timer.invalidate()
//        //if we want to clear the text, erase our progress
//        if clearText {
//            showTextCount = 0
//            partialText = ""
//        }
//    }
//
//    //convenience function for calling stop(clearText: true)
//    func reset() {
//        stop(clearText: true)
//    }
//
//    var body: some View {
//        ScrollView {
//            Text(self.partialText).font(.custom("Inter-Regular", size: 16))
//                .foregroundColor(Color.theme.eerieBlack)
//                .padding(.horizontal, 16)
//                .padding(.vertical, 12)
//        }.frame(maxWidth: .infinity, maxHeight: 200)
//    }
//}

enum Status {
    case normal
    case like
    case dislike
}

func getDestination(screen: NavigationEnumeration, item: ListFlightSplitItem, row: ListFlightSplitItem) -> AnyView {
    if screen == NavigationEnumeration.TableScreen {
        return AnyView(TableDetailSplit(row: row))
    } else {
        if row.screen == NavigationEnumeration.NoteScreen {
            return AnyView(FlightPlanSplit())
        }
        
        if row.screen == NavigationEnumeration.AirCraftScreen {
            return AnyView(AircraftSplit())
        }
        
        if row.screen == NavigationEnumeration.DepartureScreen {
            return AnyView(DepartureSplit())
        }
        
        if row.screen == NavigationEnumeration.EnrouteScreen {
            return AnyView(EnrouteSplit())
        }
        
        if row.screen == NavigationEnumeration.ArrivalScreen {
            return AnyView(ArrivalSplit())
        }
        
        if row.screen == NavigationEnumeration.AtlasSearchScreen {
            return AnyView(AtlasSearchSplit())
        }
        
        return AnyView(FlightPlanSplit())
    }
}

