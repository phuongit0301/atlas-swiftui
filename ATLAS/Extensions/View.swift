//
//  View.swift
//  ATLAS
//
//  Created by phuong phan on 24/05/2023.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseAuth


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
    
    func hasMainTabbar() -> some View {
        ModifiedContent(content: self, modifier: HasMainTabbar())
    }
    
    func breadCrumb(_ screenName: NavigationEnumeration = NavigationEnumeration.FlightPlanScreen) -> some View {
        ModifiedContent(content: self, modifier: BreadCrumb(screenName: screenName))
    }
    
    func breadCrumbRef(_ screenName: NavigationEnumeration = NavigationEnumeration.FlightPlanScreen, _ parentScreenName: NavigationEnumeration? = NavigationEnumeration.OverviewScreen) -> some View {
        ModifiedContent(content: self, modifier: BreadCrumbRef(screenName: screenName, parentScreenName: parentScreenName))
    }
    
    func breadCrumbNotamRef(_ screenName: NavigationEnumeration = NavigationEnumeration.FlightPlanScreen, _ parentScreenName: NavigationEnumeration? = NavigationEnumeration.OverviewScreen) -> some View {
        ModifiedContent(content: self, modifier: BreadCrumbNotamRef(screenName: screenName, parentScreenName: parentScreenName))
    }
    
    func hideKeyboardWhenTappedAround() -> some View  {
            return self.onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                      to: nil, from: nil, for: nil)
            }
        }
    
    func onAppWentToBackground(perform action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            action()
        }
    }
    
    public func formSheet<Content: View>(isPresented: Binding<Bool>,
                                         @ViewBuilder content: @escaping () -> Content) -> some View {
        self.background(FormSheet(show: isPresented, content: content))
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

struct TypingText: View {
    @State private var text = ""
    let fullText: String
    let typingIntervalRange: ClosedRange<Double>

    init(text: String, typingIntervalRange: ClosedRange<Double> = 0.03...0.05) {
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
        }.frame(maxWidth: .infinity, alignment: .leading)
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

enum Status {
    case normal
    case like
    case dislike
}

//func getDestination(_ item: ListFlightInformationItem) -> AnyView {
//    if item.screenName == NavigationEnumeration.AirCraftScreen {
//        return AnyView(
//            AircraftReferenceContainer()
//                .navigationBarBackButtonHidden()
//                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
//                .ignoresSafeArea()
//
//        )
//    }
//
//    if item.screenName == NavigationEnumeration.FuelScreen {
//        return AnyView(
//            FuelView()
//                .navigationBarBackButtonHidden()
//                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
//                .ignoresSafeArea()
//        )
//    }
//
//    if item.screenName == NavigationEnumeration.DepartureScreen {
//        return AnyView(
//            DepartureReferenceContainer()
//                .navigationBarBackButtonHidden()
////                .navigationBarHidden(true)
//                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
//                .ignoresSafeArea()
//        )
//    }
//
//    if item.screenName == NavigationEnumeration.EnrouteScreen {
//        return AnyView(
//            EnrouteReferenceContainer()
//                .navigationBarBackButtonHidden()
////                .navigationBarHidden(true)
//                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
//                .ignoresSafeArea()
//        )
//    }
//
//    if item.screenName == NavigationEnumeration.ArrivalScreen {
//        return AnyView(
//            ArrivalReferenceContainer()
//                .navigationBarBackButtonHidden()
////                .navigationBarHidden(true)
//                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
//                .ignoresSafeArea()
//        )
//    }
//
//    if item.screenName == NavigationEnumeration.AtlasSearchScreen {
//        return AnyView(
//            PreviousSearchReferenceView(title: "AI Search")
//                .navigationBarBackButtonHidden()
//                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
//                .ignoresSafeArea()
//        )
//    }
//
//    if item.screenName == NavigationEnumeration.FlightPlanScreen {
//        return AnyView(
//            FlightPlanView()
//                .navigationBarBackButtonHidden()
//                .breadCrumb(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
//                .ignoresSafeArea()
//        )
//    }
//
//    if item.screenName == NavigationEnumeration.FlightInformationDetailScreen {
//        return AnyView(
//            FlightOverviewSectionView(isReference: true)
//                .navigationBarBackButtonHidden()
////                .navigationBarHidden(true)
//                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
//                .ignoresSafeArea()
//        )
//    }
//
//    if item.screenName == NavigationEnumeration.PreflightSectionView {
//        return AnyView(
//            PreflightSectionView()
//                .navigationBarBackButtonHidden()
//                .breadCrumbRef(item.screenName ?? NavigationEnumeration.PreflightSectionView)
//                .ignoresSafeArea()
//        )
//    }
//
//    if item.screenName == NavigationEnumeration.NotamDetailScreen {
//        return AnyView(
//            FlightPlanNOTAMReferenceView()
//                .navigationBarBackButtonHidden()
////                .navigationBarHidden(true)
//                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
//                .ignoresSafeArea()
//        )
//    }
//
//    if item.screenName == NavigationEnumeration.ScratchPadScreen {
//        return AnyView(
//            ScratchPadView()
//                .navigationBarBackButtonHidden()
////                .navigationBarHidden(true)
//                .breadCrumbRef(item.screenName ?? NavigationEnumeration.FlightPlanScreen)
//                .ignoresSafeArea()
//        )
//    }
//
//    return AnyView(
//        ClipboardFlightOverviewView()
//            .navigationBarBackButtonHidden()
//            .breadCrumb(item.screenName ?? NavigationEnumeration.ClipboardFlightOverviewScreen)
//            .ignoresSafeArea()
//    )
//}

func getDestinationSplit(_ item: ListFlightInformationItem) -> AnyView {
    if item.screenName == NavigationEnumeration.ClipboardPreflight {
        return AnyView(SlideoverPreflightView().navigationBarBackButtonHidden().ignoresSafeArea())
    }
    
    if item.screenName == NavigationEnumeration.ClipboardCrewBriefing {
        return AnyView(SlideoverCrewBriefing().navigationBarBackButtonHidden().ignoresSafeArea())
    }
    
    if item.screenName == NavigationEnumeration.ClipboardDepature {
        return AnyView(SlideoverDepature().navigationBarBackButtonHidden().ignoresSafeArea())
    }
    
    if item.screenName == NavigationEnumeration.ClipboardEnroute {
        return AnyView(SlideoverEnroute().navigationBarBackButtonHidden().ignoresSafeArea())
    }
    
    if item.screenName == NavigationEnumeration.ClipboardArrival {
        return AnyView(SlideoverArrival().navigationBarBackButtonHidden().ignoresSafeArea())
    }
    
    if item.screenName == NavigationEnumeration.ClipboardAISearch {
        return AnyView(SlideoverAISearchResult().navigationBarBackButtonHidden().ignoresSafeArea())
    }
    
    return AnyView(SlideoverOverviewView().navigationBarBackButtonHidden().ignoresSafeArea())
}

func getDestinationNextSplit(_ item: ListFlightInformationItem, _ listItem: [ListFlightInformationItem]) -> AnyView {
    
    if let index = listItem.firstIndex(where: {$0.screenName == item.screenName}) {
        if item.nextScreen == NavigationEnumeration.DepartureScreen {
            return AnyView(DepartureSplit(item: listItem[3]))
        }
        
        if item.nextScreen == NavigationEnumeration.EnrouteScreen {
            return AnyView(EnrouteSplit(item: listItem[index + 1]))
        }
        
        if item.nextScreen == NavigationEnumeration.ArrivalScreen {
            return AnyView(ArrivalSplit(item: listItem[index + 1]))
        }
    }
    
    return AnyView(DepartureSplit(item: listItem[3]))
}

func getDestinationTable(_ item: ListFlightInformationItem) -> AnyView {
    return AnyView(
        TableDetail(row: item)
            .navigationBarBackButtonHidden()
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
    @AppStorage("uid") var userID: String = ""

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
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                withAnimation {
                                    userID = ""
                                }
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                        }) {
//                                Image(systemName: "rectangle.portrait.and.arrow.right")
//                                    .scaledToFit()
//                                    .aspectRatio(contentMode: .fit).accentColor(.black)
//                                
                                Text("Logout").font(.system(size: 17)).foregroundColor(.black)
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

public struct HasMainTabbar: ViewModifier {
    @EnvironmentObject var modelState: MainTabModelState
    
    public func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Tabs
            MainTabbarScrollable(tabbarItems: modelState.tabs, selectedTab: $modelState.selectedTab).previewDisplayName("MainTabBarView")
            content
        }.background(Color.theme.sonicSilver.opacity(0.12))
    }
}

public struct BreadCrumbNotamRef: ViewModifier {
    @EnvironmentObject var refState: ScreenReferenceModel
    @Environment(\.dismiss) private var dismiss
    var screenName: NavigationEnumeration
    var parentScreenName: NavigationEnumeration? = NavigationEnumeration.OverviewScreen
    
    public func body(content: Content) -> some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                HStack {
                    Button {
                        refState.isActive = false
                        refState.selectedItem = nil
                        refState.isTable = false
                    } label: {
                        HStack {
                            if let parentScreenName = parentScreenName {
                                Text(convertScreenNameToString(parentScreenName)).font(.system(size: 13, weight: .semibold)).foregroundColor(Color.theme.azure)
                            }
                        }
                    }
                    Image(systemName: "chevron.forward").resizable().padding(.horizontal, 5).frame(width: 18, height: 11).aspectRatio(contentMode: .fit)
                    Text("\(convertScreenNameToString(screenName))").font(.system(size: 13, weight: .semibold)).foregroundColor(.black)
                }.padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 1))
                    
            }.padding()
            .background(Color(.systemGroupedBackground))
            
            content
        }
    }
}

public struct BreadCrumbRef: ViewModifier {
    @EnvironmentObject var refState: ScreenReferenceModel
    @Environment(\.dismiss) private var dismiss
    var screenName: NavigationEnumeration
    var parentScreenName: NavigationEnumeration? = NavigationEnumeration.OverviewScreen
    
    public func body(content: Content) -> some View {
        VStack (alignment: .leading, spacing: 0) {
            VStack (alignment: .leading, spacing: 0) {

                HStack(alignment: .center) {
                    Button {
                        refState.isActive = false
                        refState.selectedItem = nil
                        refState.isTable = false
                    } label: {
                        HStack {
                            if let parentScreenName = parentScreenName {
                                Text(convertScreenNameToString(parentScreenName)).font(.system(size: 13, weight: .semibold)).foregroundColor(Color.theme.azure)
                            }
                        }
                    }
                    Image(systemName: "chevron.forward").resizable().padding(.horizontal, 5).frame(width: 18, height: 11).aspectRatio(contentMode: .fit)
                    Text("\(convertScreenNameToString(screenName))").font(.system(size: 13, weight: .semibold)).foregroundColor(.black)
                }.padding(.vertical)
                
                content
                
            }.padding()
                .background(Color.white)
                .cornerRadius(8)
        }.padding(.horizontal)
            .padding(.vertical, 36)
            .background(Color.theme.antiFlashWhite)
            
    }
}

public struct BreadCrumb: ViewModifier {
    @EnvironmentObject var refState: ScreenReferenceModel
    var screenName: NavigationEnumeration
    
    public func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack {
                        HStack(alignment: .center) {
                            Button {
                                refState.isActive = false
                            } label: {
                                HStack {
                                    Text("Reference").font(.system(size: 13, weight: .semibold)).foregroundColor(Color.theme.azure)
                                }
                            }
                            Image(systemName: "chevron.forward").resizable().padding(.horizontal, 5).frame(width: 18, height: 11).aspectRatio(contentMode: .fit)
                            Text("\(convertScreenNameToString(screenName))").font(.system(size: 13, weight: .semibold)).foregroundColor(.black)
                        }.padding()
                    }
                }
            }
    }
}

func convertScreenNameToString(_ screenName: NavigationEnumeration) -> String {
    switch screenName {
        case .FlightOverviewSectionView:
            return "Flight Overview"
        case .SummarySubSectionView:
            return "Summary"
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
            return "Flight Summary"
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
        //New
        case .ClipboardFlightOverviewScreen:
            return "Flight Overview"
        case .ClipboardPreflight:
            return "Preflight"
        case .ClipboardCrewBriefing:
            return "Crew Briefing"
        case .ClipboardDepature:
            return "Departure"
        case .ClipboardEnroute:
            return "Enroute"
        case .ClipboardArrival:
            return "Arrival"
        case .ClipboardAISearch:
            return "AI Search Results"
        default:
            return "Flight Overview"
    }
}

class FormSheetWrapper<Content: View>: UIViewController, UIPopoverPresentationControllerDelegate {

    var content: () -> Content
    var onDismiss: (() -> Void)?

    private var hostVC: UIHostingController<Content>?

    required init?(coder: NSCoder) { fatalError("") }

    init(content: @escaping () -> Content) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }

    func show() {
        guard hostVC == nil else { return }
        let vc = UIHostingController(rootView: content())

//        vc.view.sizeToFit()
//        vc.preferredContentSize = vc.view.bounds.size

        vc.modalPresentationStyle = .formSheet
        vc.presentationController?.delegate = self
        hostVC = vc
        self.present(vc, animated: true, completion: nil)
    }

    func hide() {
        guard let vc = self.hostVC, !vc.isBeingDismissed else { return }
        dismiss(animated: true, completion: nil)
        hostVC = nil
    }

    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        hostVC = nil
        self.onDismiss?()
    }
}

struct FormSheet<Content: View> : UIViewControllerRepresentable {

    @Binding var show: Bool

    let content: () -> Content

    func makeUIViewController(context: UIViewControllerRepresentableContext<FormSheet<Content>>) -> FormSheetWrapper<Content> {

        let vc = FormSheetWrapper(content: content)
        vc.onDismiss = { self.show = false }
        return vc
    }

    func updateUIViewController(_ uiViewController: FormSheetWrapper<Content>,
                                context: UIViewControllerRepresentableContext<FormSheet<Content>>) {
        if show {
            uiViewController.show()
        }
        else {
            uiViewController.hide()
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        // test@email.com -> true
        // test.com -> false
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        
        return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
        
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()
