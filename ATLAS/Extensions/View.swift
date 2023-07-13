//
//  View.swift
//  ATLAS
//
//  Created by phuong phan on 24/05/2023.
//

import Foundation
import SwiftUI
import UIKit

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
    
    func hasToolbar() -> some View {
        ModifiedContent(content: self, modifier: HasToolbar())
    }
    
    func hasTabbar() -> some View {
        ModifiedContent(content: self, modifier: HasTabbar())
    }
    
    func breadCrumb(_ screenName: NavigationEnumeration = NavigationEnumeration.FlightPlanScreen) -> some View {
        ModifiedContent(content: self, modifier: BreadCrumb(screenName: screenName))
    }
    
    func breadCrumbRef(_ screenName: NavigationEnumeration = NavigationEnumeration.FlightPlanScreen, _ parentScreenName: NavigationEnumeration? = NavigationEnumeration.OverviewScreen) -> some View {
        ModifiedContent(content: self, modifier: BreadCrumbRef(screenName: screenName, parentScreenName: parentScreenName))
    }
    
    func hideKeyboardWhenTappedAround() -> some View  {
            return self.onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                      to: nil, from: nil, for: nil)
            }
        }
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
    
//    func toDateFormat( inputDateFormat inputFormat  : String,  ouputDateFormat outputFormat  : String ) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = inputFormat
//        if let date = (dateFormatter.date(from: self) != nil) {
////            let date = dateFormatter.date(from: self)
//            dateFormatter.dateFormat = outputFormat
//            return dateFormatter.string(from: date)
//        }
//        else {
//            return ""
//        }
//    }
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

struct TypingText: View {
    @State private var text = ""
    let fullText: String
    let typingIntervalRange: ClosedRange<Double>

    init(text: String, typingIntervalRange: ClosedRange<Double> = 0.05...0.15) {
        self.fullText = text
        self.typingIntervalRange = typingIntervalRange
    }

    var body: some View {
        ScrollView {
            Text(text)
                .font(.custom("Inter-Regular", size: 16))
                    .foregroundColor(Color.theme.eerieBlack)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                .onAppear {
                    self.typeText()
                }
        }.frame(maxWidth: .infinity)
    }

    func typeText() {
        var currentIndex = text.endIndex
        Timer.scheduledTimer(withTimeInterval: randomTypingInterval(), repeats: true) { timer in
            if currentIndex < self.fullText.endIndex {
                currentIndex = self.fullText.index(after: currentIndex)
                self.text = String(self.fullText[..<currentIndex])
                timer.invalidate()
                self.typeText()
            } else {
                timer.invalidate()
            }
        }
    }

    func randomTypingInterval() -> Double {
        let interval = Double.random(in: typingIntervalRange)
        return interval
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

func getDestination(_ item: ListFlightInformationItem) -> AnyView {
    if item.screenName == NavigationEnumeration.AirCraftScreen {
        return AnyView(
            AircraftReferenceContainer()
                .navigationBarBackButtonHidden()
                .navigationBarHidden(true)
                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
                .ignoresSafeArea()
            
        )
    }
    
    if item.screenName == NavigationEnumeration.FuelScreen {
        return AnyView(
            FuelView()
                .navigationBarBackButtonHidden()
                .breadCrumb(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
                .ignoresSafeArea()
        )
    }
    
    if item.screenName == NavigationEnumeration.DepartureScreen {
        return AnyView(
            DepatureReferenceContainer()
                .navigationBarBackButtonHidden()
                .navigationBarHidden(true)
                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
                .ignoresSafeArea()
        )
    }
    
    if item.screenName == NavigationEnumeration.EnrouteScreen {
        return AnyView(
            EnrouteReferenceContainer()
                .navigationBarBackButtonHidden()
                .navigationBarHidden(true)
                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
                .ignoresSafeArea()
        )
    }
    
    if item.screenName == NavigationEnumeration.ArrivalScreen {
        return AnyView(
            ArrivalReferenceContainer()
                .navigationBarBackButtonHidden()
                .navigationBarHidden(true)
                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
                .ignoresSafeArea()
        )
    }
    
    if item.screenName == NavigationEnumeration.AtlasSearchScreen {
        return AnyView(
            AISearchView()
                .navigationBarBackButtonHidden()
                .breadCrumb(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
                .ignoresSafeArea()
        )
    }
    
    if item.screenName == NavigationEnumeration.FlightPlanScreen {
        return AnyView(
            FlightPlanView()
                .navigationBarBackButtonHidden()
                .breadCrumb(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
                .ignoresSafeArea()
        )
    }
    
    if item.screenName == NavigationEnumeration.FlightInformationDetailScreen {
        return AnyView(
            FlightInformationDetailView()
                .navigationBarBackButtonHidden()
                .navigationBarHidden(true)
                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
                .ignoresSafeArea()
        )
    }
    
    if item.screenName == NavigationEnumeration.NotamDetailScreen {
        return AnyView(
            NotamDetailView()
                .navigationBarBackButtonHidden()
                .navigationBarHidden(true)
                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
                .ignoresSafeArea()
        )
    }
    
    if item.screenName == NavigationEnumeration.ScratchPadScreen {
        return AnyView(
            ScratchPadView()
                .navigationBarBackButtonHidden()
                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
                .ignoresSafeArea()
        )
    }
    
    return AnyView(
        FlightPlanView()
            .navigationBarBackButtonHidden()
            .breadCrumb(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
            .ignoresSafeArea()
    )
}

func getDestinationSplit(_ item: ListFlightInformationItem) -> AnyView {
    if item.screenName == NavigationEnumeration.AirCraftScreen {
        return AnyView(AircraftSplit())
    }
    
//    if item.screenName == NavigationEnumeration.FuelScreen {
//        return AnyView(FuelViewSplit())
//    }
    
    if item.screenName == NavigationEnumeration.FlightInformationDetailScreen {
        return AnyView(FlightInformationDetailSplitView())
    }
    
    if item.screenName == NavigationEnumeration.NoteScreen {
        return AnyView(FlightPlanSplit())
    }
    
    if item.screenName == NavigationEnumeration.DepartureScreen {
        return AnyView(DepartureSplit())
    }
    
    if item.screenName == NavigationEnumeration.EnrouteScreen {
        return AnyView(EnrouteSplit())
    }
    
    if item.screenName == NavigationEnumeration.ArrivalScreen {
        return AnyView(ArrivalSplit())
    }
    
    if item.screenName == NavigationEnumeration.AtlasSearchScreen {
        return AnyView(AtlasSearchSplit())
    }
    
    return AnyView(FlightPlanSplit())
}

func getDestinationTable(_ item: ListFlightInformationItem) -> AnyView {
    return AnyView(
        TableDetail(row: item)
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
            .ignoresSafeArea()
    )
}

func getDestinationSplitTable(_ item: ListFlightInformationItem) -> AnyView {
    return AnyView(
        TableDetailSplit(row: item)
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .ignoresSafeArea()
    )
}

//final class SwiftUIViewController: UIHostingController<hasTabbar> {
//    required init?(coder: NSCoder) {
//        super.init(coder: coder, rootView: hasTabbar())
//        rootView.dismiss = dismiss
//    }
//
//    init() {
//        super.init(rootView: hasTabbar())
//        rootView.dismiss = dismiss
//    }
//
//    func dismiss() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        rootView.prepareExit()
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        rootView.doExit()
//    }
//}


public struct HasToolbar: ViewModifier {
    @EnvironmentObject var sideMenuState: SideMenuModelState
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?

    public func body(content: Content) -> some View {
        if verticalSizeClass == .regular && horizontalSizeClass == .compact {
            content
        } else {
            content
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.white, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("icon_arrow_left")
                                .frame(width: 41, height: 72)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            
                        }) {
                            Image("icon_arrow_right")
                                .frame(width: 41, height: 72)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        HStack(alignment: .center) {
                            Text(sideMenuState.selectedMenu?.name ?? "").foregroundColor(Color.theme.eerieBlack).padding(.horizontal, 20).font(.custom("Inter-SemiBold", size: 17))
                            
                            Text(sideMenuState.selectedMenu?.flight ?? "").foregroundColor(Color.theme.eerieBlack).padding(.horizontal, 20).font(.custom("Inter-SemiBold", size: 17))
                            
                            Text(sideMenuState.selectedMenu?.date ?? "").foregroundColor(Color.theme.eerieBlack).padding(.horizontal, 20).font(.custom("Inter-SemiBold", size: 17))
                        }
                    }
                }
        }
    }
}

public struct HasTabbar: ViewModifier {
    @EnvironmentObject var modelState: TabModelState
    
    public func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Tabs
            TabbarScrollable(tabbarItems: modelState.tabs, selectedTab: $modelState.selectedTab).previewDisplayName("TabBarView")
            content
        }.background(Color.theme.sonicSilver.opacity(0.12))
    }
}

public struct BreadCrumbRef: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    var screenName: NavigationEnumeration
    var parentScreenName: NavigationEnumeration? = NavigationEnumeration.OverviewScreen
    
    public func body(content: Content) -> some View {
        VStack (alignment: .leading, spacing: 0) {
            VStack (alignment: .leading, spacing: 0) {

                HStack(alignment: .center) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            if let parentScreenName = parentScreenName {
                                Text(convertScreenNameToString(parentScreenName)).font(.system(size: 11, weight: .semibold)).foregroundColor(Color.theme.azure)
                            }
                        }
                    }
                    Image(systemName: "chevron.forward").resizable().padding(.horizontal, 5).frame(width: 18, height: 11).aspectRatio(contentMode: .fit)
                    Text("\(convertScreenNameToString(screenName))").font(.system(size: 11, weight: .semibold)).foregroundColor(.black)
                }.padding()
                
                content.padding(.horizontal)
                
            }.padding()
                .background(Color.white)
                .cornerRadius(8)
        }.padding()
            .background(screenName == NavigationEnumeration.FlightInformationDetailScreen ? Color.white : Color.theme.antiFlashWhite)
            
    }
}

public struct BreadCrumb: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    var screenName: NavigationEnumeration
    
    public func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack {
                        Rectangle().fill(Color.clear).frame(height: screenName == NavigationEnumeration.FuelScreen ? 8 : 16 )
                        HStack(alignment: .center) {
                            Button {
                                dismiss()
                            } label: {
                                HStack {
                                    Text("Reference").font(.system(size: 11, weight: .semibold)).foregroundColor(Color.theme.azure)
                                }
                            }
                            Image(systemName: "chevron.forward").resizable().padding(.horizontal, 5).frame(width: 18, height: 11).aspectRatio(contentMode: .fit)
                            Text("\(convertScreenNameToString(screenName))").font(.system(size: 11, weight: .semibold)).foregroundColor(.black)
                        }.padding()
                        if screenName == NavigationEnumeration.FuelScreen || screenName == NavigationEnumeration.FlightPlanScreen {
                            Rectangle().fill(Color.clear).frame(height: 8)
                        }
                    }
                }
            }
    }
}

func convertScreenNameToString(_ screenName: NavigationEnumeration) -> String {
    switch screenName {
        case .HomeScreen:
            return "Home"
        case .FlightScreen:
            return "Flight Note"
        case .OverviewScreen:
            return "Reference"
        case .NoteScreen:
            return "Note"
        case .FlightPlanScreen:
            return "Flight Plan"
        case .FlightInformationDetailScreen:
            return "Flight Information"
        case .NotamDetailScreen:
            return "NOTAMs"
        case .AirCraftScreen:
            return "Aircraft Status"
        case .DepartureScreen:
            return "Departure"
        case .EnrouteScreen:
            return "Enroute"
        case .ArrivalScreen:
            return "Arrival"
        case .AtlasSearchScreen:
            return "AI Search"
        case .TableScreen:
            return "Utilities"
        case .FuelScreen:
            return "Fuel"
        case .ChartScreen:
            return "Chart"
        case .WeatherScreen:
            return "Weather"
        case .ReportingScreen:
            return "Reporting"
        case .ScratchPadScreen:
            return "Scratch Pad"
    }
}
