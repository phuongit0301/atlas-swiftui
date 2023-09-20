//
//  FlightPlanModel.swift
//  ATLAS
//
//  Created by phuong phan on 17/06/2023.
//

import Foundation
import SwiftUI
import Combine

enum FlightPlanEnumeration: CustomStringConvertible {
    case SummaryScreen
    case DepartureScreen
    case EnrouteScreen
    case ArrivalScreen
    case NOTAMScreen
    case METARSScreen
    
    var description: String {
        switch self {
            case .SummaryScreen:
                return "Summary"
            case .DepartureScreen:
                return "Departure"
            case .EnrouteScreen:
                return "Enroute"
            case .ArrivalScreen:
                return "Arrival"
            case .NOTAMScreen:
                return "NOTAM"
            case .METARSScreen:
                return "METARS"
        }
    }
}

struct Tab {
    var icon: Image?
    var title: String
    var screenName: FlightPlanEnumeration
}

let IFlightPlanTabs = [
    Tab(title: "Summary", screenName: FlightPlanEnumeration.SummaryScreen),
    Tab(title: "NOTAM", screenName: FlightPlanEnumeration.NOTAMScreen),
    Tab(title: "METAR / TAF", screenName: FlightPlanEnumeration.METARSScreen),
    Tab(title: "Departure", screenName: FlightPlanEnumeration.DepartureScreen),
    Tab(title: "Enroute", screenName: FlightPlanEnumeration.EnrouteScreen),
    Tab(title: "Arrival", screenName: FlightPlanEnumeration.ArrivalScreen),
]
//
//struct IFlightPlanTabs {
//    let ListItem = {
//        let MainItem = [
//            Tab(title: "Summary", screenName: FlightPlanEnumeration.SummaryScreen),
//            Tab(title: "Departure", screenName: FlightPlanEnumeration.DepartureScreen),
//            Tab(title: "Enroute", screenName: FlightPlanEnumeration.EnrouteScreen),
//            Tab(title: "Arrival", screenName: FlightPlanEnumeration.ArrivalScreen),
//            Tab(title: "NOTAM", screenName: FlightPlanEnumeration.NOTAMScreen),
//            Tab(title: "METARS", screenName: FlightPlanEnumeration.METARSScreen)
//        ]
//
//        return MainItem
//    }()
//}

struct IFPSplitModel: Identifiable, Encodable, Decodable {
    var id = UUID()
    var name: String
    var date: String
    var isFavourite: Bool = false
}

// For Flight Plan Split
class FPModelSplitState: ObservableObject {
    
    // Flight Plan Split
    @AppStorage("fpSplitArray") private var fpSplitDataStorage: Data = Data()
    
    @Published var fpSplitArray: [IFPSplitModel] = [] {
        didSet {
            saveFPSplit()
        }
    }
    
    init() {
        loadFPSplit()
    }
    
    private func loadFPSplit() {
        guard let decodedArray = try? JSONDecoder().decode([IFPSplitModel].self, from: fpSplitDataStorage)
        else {
            fpSplitArray = [
                IFPSplitModel(name: "Scheduled Departure", date: "XX:XX", isFavourite: false),
                IFPSplitModel(name: "POB", date: "XX:XX", isFavourite: false),
            ]
            return
        }
        
        fpSplitArray = decodedArray
    }
    
    private func saveFPSplit() {
        guard let encodedArray = try? JSONEncoder().encode(fpSplitArray) else {
            return
        }
        fpSplitDataStorage = encodedArray
    }
}

func calculateWidth(_ width: CGFloat, _ size: Int) -> CGFloat {
    return width - CGFloat(100) <= 0 ? 0 : CGFloat((width - CGFloat(100)) / CGFloat(size))
}

class StepperObject: ObservableObject {
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var step: Int = 1
    @Published var range: ClosedRange<Int> = 0...100
}

class ViewModelSummary: ObservableObject {
    @Published var list = [Int: String]()
    @Published var listString = [String: String]()
    @Published var field: String = ""
    @Published var showSheet: Bool = false
}

struct Field: View {
    
    // Read the view model, to store the value of the text field
    @EnvironmentObject var viewModel: ViewModelSummary
    
    // Index: where in the dictionary the value will be stored
    let index: Int
    
    // Dedicated state var for each field
    @State private var field = ""
    
    var body: some View {
        TextField("Enter remarks (optional)", text: $field)
    }
    
    // Store the value in the dictionary
    private func store() {
        viewModel.list[index] = field
    }
}

struct FieldString: View {
    // Read the view model, to store the value of the text field
    @EnvironmentObject var viewModel: ViewModelSummary
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    // Index: where in the dictionary the value will be stored
    let name: String
    
    // Dedicated state var for each field
    @Binding var field: String
    @FocusState var focusedTextField: Bool
    @Binding var isEditing: Bool
    var setFocusToFalse: () -> Void
    
    var body: some View {
        TextField(name.uppercased(), text: $field)
            .overlay(isEditing ? Rectangle().stroke(Color.red, lineWidth:1) : nil)
            .font(.system(size: 15))
            .focused($focusedTextField)
            .onReceive(Just(focusedTextField)) { newFocused in
                if newFocused {
                    setFocusToFalse()
                    isEditing = true
                }
            }
    }
}

struct FieldStringDefaultKB: View {
    // Read the view model, to store the value of the text field
    @EnvironmentObject var viewModel: ViewModelSummary
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    // Index: where in the dictionary the value will be stored
    let name: String
    
    // Dedicated state var for each field
    @State var field: String = ""
    
    var body: some View {
        TextField("Enter remarks (optional)", text: $field)
            .font(.system(size: 15))
            .onAppear {
                let item = coreDataModel.dataFuelExtra!
                
                switch name {
                    case "remarkArrDelays":
                        field = item.unwrappedRemarkArrDelays
                    case "remarkTaxi":
                        field = item.unwrappedRemarkTaxi
                    case "remarkFlightLevel":
                        field = item.unwrappedRemarkFlightLevel
                    case "remarkTrackShortening":
                        field = item.unwrappedRemarkTrackShortening
                    case "remarkEnrWx":
                        field = item.unwrappedRemarkEnrWx
                    case "remarkReciprocalRwy":
                        field = item.unwrappedRemarkReciprocalRwy
                    case "remarkZFWChange":
                        field = item.unwrappedRemarkZFWChange
                    case "remarkOthers":
                        field = item.unwrappedRemarkOthers
                    default:
                        field = ""
                }
            }
            .onSubmit {
                var item = coreDataModel.dataFuelExtra!
                
                if !coreDataModel.existDataFuelExtra {
                    item = FuelExtraList(context: persistenceController.container.viewContext)
                }
                
                switch name {
                case "remarkArrDelays":
                    item.remarkArrDelays = field
                case "remarkTaxi":
                    item.remarkTaxi = field
                case "remarkFlightLevel":
                    item.remarkFlightLevel = field
                case "remarkTrackShortening":
                    item.remarkTrackShortening = field
                case "remarkEnrWx":
                    item.remarkEnrWx = field
                case "remarkReciprocalRwy":
                    item.remarkReciprocalRwy = field
                case "remarkZFWChange":
                    item.remarkZFWChange = field
                case "remarkOthers":
                    item.remarkOthers = field
                default:
                    item.remarkArrDelays = field
                }
                
                coreDataModel.save()
                coreDataModel.readFlightPlan()
            }
    }
}

//struct FieldString: View {
//    // Read the view model, to store the value of the text field
//    @EnvironmentObject var viewModel: ViewModelSummary
//    @EnvironmentObject var coreDataModel: CoreDataModelState
//    @EnvironmentObject var persistenceController: PersistenceController
//
//    // Index: where in the dictionary the value will be stored
//    let name: String
//
//    // Dedicated state var for each field
//    @State var field: String = ""
//    @FocusState var focusedTextField: FocusElement?
//    @Binding var isEditing: Bool
//    var setFocusToFalse: () -> Void
//
//    var body: some View {
//        TextField("Enter remarks (optional)", text: $field)
//            .font(.system(size: 15))
//            .onAppear {
//                let item = coreDataModel.dataFuelExtra!
//
//                switch name {
//                    case "remarkArrDelays":
//                        field = item.unwrappedRemarkArrDelays
//                    case "remarkTaxi":
//                        field = item.unwrappedRemarkTaxi
//                    case "remarkFlightLevel":
//                        field = item.unwrappedRemarkFlightLevel
//                    case "remarkTrackShortening":
//                        field = item.unwrappedRemarkTrackShortening
//                    case "remarkEnrWx":
//                        field = item.unwrappedRemarkEnrWx
//                    case "remarkReciprocalRwy":
//                        field = item.unwrappedRemarkReciprocalRwy
//                    case "remarkZFWChange":
//                        field = item.unwrappedRemarkZFWChange
//                    case "remarkOthers":
//                        field = item.unwrappedRemarkOthers
//                    default:
//                        field = ""
//                }
//            }
//            .focused($focusedTextField, equals: .remarkArrDelays)
////            .onReceive(Just(focusedTextField)) { newFocused in
////                print("newFocused========\(newFocused)")
//////                if newFocused {
//////                    setFocusToFalse()
//////                    isEditing = true
//////                }
////            }
//            .onSubmit {
//                var item = coreDataModel.dataFuelExtra!
//
//                if !coreDataModel.existDataFuelExtra {
//                    item = FuelExtraList(context: persistenceController.container.viewContext)
//                }
//
//                switch name {
//                case "remarkArrDelays":
//                    item.remarkArrDelays = field
//                case "remarkTaxi":
//                    item.remarkTaxi = field
//                case "remarkFlightLevel":
//                    item.remarkFlightLevel = field
//                case "remarkTrackShortening":
//                    item.remarkTrackShortening = field
//                case "remarkEnrWx":
//                    item.remarkEnrWx = field
//                case "remarkReciprocalRwy":
//                    item.remarkReciprocalRwy = field
//                case "remarkZFWChange":
//                    item.remarkZFWChange = field
//                case "remarkOthers":
//                    item.remarkOthers = field
//                default:
//                    item.remarkArrDelays = field
//                }
//
//                coreDataModel.save()
//                coreDataModel.readFlightPlan()
//            }
//    }
//}

struct CustomField: View {
    // Read the view model, to store the value of the text field
    @EnvironmentObject var viewModel: ViewModelSummary
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    // Index: where in the dictionary the value will be stored
//    let name: String
    
    // Dedicated state var for each field
    @State var item: PerfWeightList = PerfWeightList()
    @State var field = ""
    
    var body: some View {
        TextField("Enter actual weight", text: $field)
            .onSubmit {
                item.actual = field
                coreDataModel.save()
                coreDataModel.dataPerfWeight = coreDataModel.readPerfWeight()
            }
            .onAppear {
                field = item.unwrappedActual
            }
    }
}

struct IAltnDataResponseModel: Codable {
    var altnRwy: String?
    var rte: String?
    var vis: String?
    var minima: String?
    var dist: String?
    var fl: String?
    var comp: String?
    var time: String?
    var fuel: String?
}

struct IFuelDataChildResponseModel: Decodable {
    var fuel: String?
    var time: String?
    var unit: String?
    
//    enum CodingKeys: String, CodingKey {
//        case fuel
//        case time
//        case unit
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        let str = try values.decode(String.self, forKey: .fuel)
//        self.fuel = "\(str)"
//    }
}

struct IFuelDataChild2ResponseModel: Decodable {
    var fuel: String?
    var policy: String?
    var time: String?
    
//    enum CodingKeys: String, CodingKey {
//        case fuel
//        case policy
//        case time
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        let str = try values.decode(String.self, forKey: .fuel)
//        self.fuel = "\(str)"
//    }
}

struct IFuelDataChild3ResponseModel: Decodable {
    var fuel: String?
    var time: String?
}

struct IFuelDataChild4ResponseModel: Decodable {
    var fuel: String?
    var policy: String?
    var time: String?
    var unit: String?
}

struct IFuelDataResponseModel: Decodable {
//    var burnoff: IFuelDataChildResponseModel
//    var cont: IFuelDataChild2ResponseModel
//    var altn: IFuelDataChildResponseModel
//    var hold: IFuelDataChildResponseModel
//    var topup60: IFuelDataChild3ResponseModel
//    var taxi: IFuelDataChild4ResponseModel
//    var planReq: IFuelDataChild3ResponseModel
//    var dispAdd: IFuelDataChild2ResponseModel
    var burnoff: [String: String]
    var cont: [String: String]
    var altn: [String: String]
    var hold: [String: String]
    var topup60: [String: String]
    var taxi: [String: String]
    var planReq: [String: String]
    var dispAdd: [String: String]
}

struct IInfoDataResponseModel: Decodable {
    var blkTime: String?
    var dep: String?
    var depICAO: String?
    var dest: String?
    var destICAO: String?
    var flightDate: String?
    var fltNo: String?
    var fltTime: String?
    var planNo: String?
    var STALocal: String?
    var STAUTC: String?
    var STDLocal: String?
    var STDUTC: String?
    var tailNo: String?
    var pob: String?
    var time_diff_arr: String?
    var time_diff_dep: String?
}

struct IAltnDataTafResponseModel: Decodable {
    var altnRwy: String?
    var eta: String?
    var taf: String?
}

struct IFlightPlanWXResponseModel: Decodable {
    var depAirport: String // For entity MetarTafDataList
    var arrAirport: String // For entity MetarTafDataList
    var depMetar: String // For entity MetarTafDataList
    var depTaf: String // For entity MetarTafDataList
    var arrMetar: String // For entity MetarTafDataList
    var arrTaf: String // For entity MetarTafDataList
    var altnTaf: [IAltnDataTafResponseModel] // For entity AltnTafDataList
}

struct INotamsDataChildResponseModel: Decodable {
    var date: String?
    var notam: String?
    var rank: String?
}

struct INotamsDataResponseModel: Decodable {
    var depNotams: [String: [INotamsDataChildResponseModel]]
    var enrNotams: [INotamsDataChildResponseModel]
    var arrNotams: [String: [INotamsDataChildResponseModel]]
//    var depNotams: [[String: String]]
//    var enrNotams: [[String: String]]
//    var arrNotams: [[String: String]]
}

struct IPerfDataResponseModel: Decodable {
    var fltRules: String?
    var gndMiles: String?
    var airMiles: String?
    var crzComp: String?
    var apd: String?
    var ci: String?
    var zfwChange: String?
    var minus_zfwChange: String?
    var lvlChange: String?
    var planZFW: String?
    var maxZFW: String?
    var limZFW: String?
    var planTOW: String?
    var maxTOW: String?
    var limTOW: String?
    var planLDW: String?
    var maxLDW: String?
    var limLDW: String?
}

// For Map
struct IWaypointData: Decodable {
    var waypoint_id: String
    var lat: String
    var long: String
}

struct IWaypointDataJson: Decodable {
    var waypoints_data: [IWaypointData]
}

struct IAirportData: Decodable {
    var airport_id: String
    var lat: String
    var long: String
}

struct IAirportDataJson: Decodable {
    var airport_data: [IAirportData]
}

struct ITrafficData: Decodable {
    var callsign: String
    var aircraft_type: String
    var lat: String
    var long: String
    var true_track: String
    var baro_altitude: String
    var colour: String
}

struct IAabbaPostCommentData: Decodable {
    var comment_id: String
    var post_id: String
    var user_id: String
    var comment_date: String
    var comment_text: String
    var username: String
}

struct IAabbaPostData: Decodable {
    var post_id: String
    var user_id: String
    var post_date: String
    var post_title: String
    var post_text: String
    var upvote_count: String
    var comment_count: String
    var category: String
    var username: String
    var comments: [IAabbaPostCommentData]
}

struct IAabbaData: Decodable {
    var name: String
    var lat: String
    var long: String
    var post_count: String
    var posts: [IAabbaPostData]
}

struct IAabbaDataJson: Decodable {
    var aabba_data: [String: [IAabbaData]]
}

struct IAirportColor: Decodable {
    var airportID: String
    var lat: String
    var long: String
    var selection: String
    var colour: String
    var notams: [String]
    var metar: String
    var taf: String
}

struct IMapDataModel: Decodable {
    let traffic_data: [ITrafficData]
    let aabba_data: [IAabbaData]
    let all_waypoints_data: [IWaypointData]
    let all_airports_data: [IAirportData]
}

struct IWaypoints: Decodable {
    var name: String
    var coord: String
}

struct ISummaryDataResponseModel: Decodable {
    var routeNo: String?
    var route: String?
    var depRwy: String?
    var arrRwy: String?
    var levels: String?
    var waypoints: [IWaypoints]
}

struct IEnrouteDataResponseModel: Decodable {
    var posn: String?
    var actm: String?
    var ztm: String?
    var eta: String?
    var ata: String?
    var afl: String?
    var oat: String?
    var adn: String?
    var aWind: String?
    var tas: String?
    var vws: String?
    var zfrq: String?
    var afrm: String?
    var Cord: String?
    var Msa: String?
    var Dis: String?
    var Diff: String?
    var Pfl: String?
    var Imt: String?
    var Pdn: String?
    var fWind: String?
    var Gsp: String?
    var Drm: String?
    var Pfrm: String?
    var fDiff: String?
}

struct IFlightPlanDataModel: Decodable {
    var altnData: [IAltnDataResponseModel] // For entity AltnDataList
    var fuelData: IFuelDataResponseModel // For entity FuelDataList
    var infoData: IInfoDataResponseModel // For entity SummaryInfoList
    var metarTafData: IFlightPlanWXResponseModel
    var notamsData: INotamsDataResponseModel // For entity NotamsDataList
    var perfData: IPerfDataResponseModel // For entity PerfDataList
    var routeData: ISummaryDataResponseModel // For entity SummaryRouteList
    var waypointsData: [IEnrouteDataResponseModel] // For entity EnrouteList
}

struct ISubDelaysModel: Codable {
    var condition: String
    var time: String
    var delay: Int
}

struct IDelaysModel: Decodable {
    var delays: [ISubDelaysModel]
    var arrTimeDelay: Int
    var arrTimeDelayWX: Int
    var eta: String
    var ymax: Int
}

struct IHistoricalDelaysModel: Decodable {
    var days3: IDelaysModel
    var week1: IDelaysModel
    var months3: IDelaysModel
}

// For Proj Delay
struct IDelays2Model: Decodable {
    var time: String
    var delay: Double
    var mindelay: Double
    var maxdelay: Double
}

struct IProjDelaysModel: Decodable {
    var delays: [IDelays2Model]
    var expectedDelay: Double
    var eta: String
}

// For Taxi
struct ITimesModel: Decodable {
    var date: String
    var condition: String
    var taxiTime: Int
}

struct IFlight3Model: Decodable {
    var times: [ITimesModel]
    var aveTime: Int
    var aveDiff: Int
    var ymax: Int
}

struct ITaxiModel: Decodable {
    var flights3: IFlight3Model
    var week1: IFlight3Model
    var months3: IFlight3Model
}

struct IFlights3TrackMile: Decodable {
    var phase: String
    var condition: String
    var trackMilesDiff: Int
}

struct ITrackMileFlightModel: Decodable {
    var trackMiles: [IFlights3TrackMile]
    var sumNM: Int
    var sumMINS: Int
}

struct ITrackMilesModel: Decodable {
    var flights3: ITrackMileFlightModel
    var week1: ITrackMileFlightModel
    var months3: ITrackMileFlightModel
}

// EnrWX
struct ITrackMileEnrWXSubModel: Decodable {
    var date: String
    var condition: String
    var trackMilesDiff: Int
}

struct ITrackMileEnrWXModel: Decodable {
    var trackMiles: [ITrackMileEnrWXSubModel]
    var aveNM: Int
    var aveMINS: Int
}

struct IEnrWXModel: Decodable {
    var flights3: ITrackMileEnrWXModel
    var week1: ITrackMileEnrWXModel
    var months3: ITrackMileEnrWXModel
}

// Flight Level
struct IFlvlFlight3SubModel: Decodable {
    var waypoint: String
    var condition: String
    var flightLevel: Int
}

struct IFlvlFlight3Model: Decodable {
    var flightLevels: [IFlvlFlight3SubModel]
    var aveDiff: Int
}

struct IFlightLevelModel: Decodable {
    var flights3: IFlvlFlight3Model
    var week1: IFlvlFlight3Model
    var months3: IFlvlFlight3Model
}

//Reciprocal RWY
struct IReciprocalRwyModel: Decodable {
    var trackMiles: [ITrackMileEnrWXSubModel]
    var aveNM: Int
    var aveMINS: Int
}

struct IFuelDataModel: Decodable {
    let historicalDelays: IHistoricalDelaysModel
    let projDelays: IProjDelaysModel
    let taxi: ITaxiModel
    let trackMiles: ITrackMilesModel
    let enrWX: IEnrWXModel
    let flightLevel: IFlightLevelModel
    let reciprocalRwy: IReciprocalRwyModel
}
