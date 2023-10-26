//
//  FlightPlanModel.swift
//  ATLAS
//
//  Created by phuong phan on 17/06/2023.
//

import Foundation
import SwiftUI
import Combine
import OSLog

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

func calculateWidthSummary(_ width: CGFloat, _ size: Int) -> CGFloat {
    return width - CGFloat(32) <= 0 ? 0 : CGFloat((width - CGFloat(32)) / CGFloat(size))
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
    var airport_id: String?
    var lat: String?
    var long: String?
    var dep_delay: String?
    var arr_delay: String?
}

struct IAirportDataJson: Decodable {
    var airport_data: [IAirportData]
}

struct ITrafficDataV30: Decodable {
    private enum CodingKeys: String, CodingKey {
        case callsign
        case aircraft_type
        case lat
        case long
        case true_track
        case baro_altitude
        case colour
    }
    
    var callsign: String
    var aircraftType: String
    var lat: String
    var long: String
    var trueTrack: String
    var baroAltitude: String
    var colour: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawCallsign = try? values.decode(String.self, forKey: .callsign)
        let rawAircraftType = try? values.decode(String.self, forKey: .aircraft_type)
        let rawLat = try? values.decode(String.self, forKey: .lat)
        let rawLong = try? values.decode(String.self, forKey: .long)
        let rawTrueTrack = try? values.decode(String.self, forKey: .true_track)
        let rawBaroAltitude = try? values.decode(String.self, forKey: .baro_altitude)
        let rawColour = try? values.decode(String.self, forKey: .colour)
        
        // Ignore with missing data.
        guard let callsignStr = rawCallsign,
              let aircraftTypeStr = rawAircraftType,
              let latStr = rawLat,
              let longStr = rawLong,
              let trueTrackStr = rawTrueTrack,
              let baroAltitudeStr = rawBaroAltitude,
              let colourStr = rawColour
        else {
            let values = "callsign = \(rawCallsign?.description ?? "nil"), "
            + "aircraftType = \(rawAircraftType?.description ?? "nil"), "
            + "lat = \(rawLat?.description ?? "nil"), "
            + "long = \(rawLong?.description ?? "nil")"
            + "trueTrack = \(rawTrueTrack?.description ?? "nil")"
            + "baroAltitude = \(rawBaroAltitude?.description ?? "nil")"
            + "colour = \(rawColour?.description ?? "nil")"

            let logger = Logger(subsystem: "insert.data.traffic", category: "parsing")
            logger.debug("Ignored: \(values)")

            throw CustomError.batchInsertError
        }
        
        self.callsign = callsignStr
        self.aircraftType = aircraftTypeStr
        self.lat = latStr
        self.long = longStr
        self.trueTrack = trueTrackStr
        self.baroAltitude = baroAltitudeStr
        self.colour = colourStr
    }
    
    // The keys must have the same name as the attributes of the Quake entity.
    var dictionaryValue: [String: Any] {
        [
            "callsign": callsign,
            "aircraftType": aircraftType,
            "latitude": lat,
            "longitude": long,
            "trueTrack": trueTrack,
            "baroAltitude": baroAltitude,
            "colour": colour
        ]
    }
}

struct ITrafficData: Codable {
    var callsign: String
    var aircraft_type: String
    var lat: String
    var long: String
    var true_track: String
    var baro_altitude: String
    var colour: String
    var vertical_speed: String
}

struct ITrafficDataResponseAPI: Codable {
    let traffic_data: [ITrafficData]
}

struct ITrafficDataResponse: Codable {
    let success: Bool
    let data: [ITrafficData]
}

struct IAabbaPostCommentData: Codable {
    var comment_id: String
    var post_id: String
    var user_id: String
    var comment_date: String
    var comment_text: String
    var username: String
}

struct IAabbaPostData: Codable {
    var post_id: String
    var user_id: String
    var post_date: String
    var post_title: String
    var post_text: String
    var upvote_count: String
    var voted: Bool
    var comment_count: String
    var category: String
    var username: String
    var comments: [IAabbaPostCommentData]?
}

struct IAabbaData: Codable {
    var name: String
    var lat: String
    var long: String
    var post_count: String
    var posts: [IAabbaPostData]
}

struct IAabbaDataJson: Codable {
    var aabba_data: [String: [IAabbaData]]
}

struct IAabbaDataJsonResponse: Codable {
    var aabba_data: [IAabbaData]
}


struct IAirportColor: Codable {
    var airportID: String?
    var lat: String?
    var long: String?
    var selection: String?
    var colour: String?
    var notams: String?
    var metar: String?
    var taf: String?
    var arr_delay: String?
    var dep_delay: String?
    var arr_delay_colour: String?
    var dep_delay_colour: String?
}

struct IMapDataModel: Decodable {
    let traffic_data: [ITrafficData]
    let aabba_data: [IAabbaData]
    let all_waypoints_data: [IWaypointData]
    let all_airports_data: [IAirportData]
}

struct IWaypointDataJsonResponse: Decodable {
    let all_waypoints_data: [IWaypointData]
}

struct IAirportDataJsonResponse: Decodable {
    let all_airports_data: [IAirportData]
    let colour_airports_data: [IAirportColor]
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

struct IDelaysModel: Codable {
    var delays: [ISubDelaysModel]
    var arrTimeDelay: Int
    var arrTimeDelayWX: Int
    var eta: String
    var ymax: Int
}

struct IHistoricalDelaysModel: Codable {
    var days3: IDelaysModel
    var week1: IDelaysModel
    var months3: IDelaysModel
}

// For Proj Delay
struct IDelays2Model: Codable {
    var time: String
    var delay: Double
    var mindelay: Double
    var maxdelay: Double
}

struct IProjDelaysModel: Codable {
    var delays: [IDelays2Model]
    var expectedDelay: Double
    var eta: String
}

// For Taxi
struct ITimesModel: Codable {
    var date: String
    var condition: String
    var taxiTime: Int
}

struct IFlight3Model: Codable {
    var times: [ITimesModel]
    var aveTime: Int
    var aveDiff: Int
    var ymax: Int
}

struct ITaxiModel: Codable {
    var flights3: IFlight3Model
    var week1: IFlight3Model
    var months3: IFlight3Model
}

struct IFlights3TrackMile: Decodable {
    var phase: String
    var condition: String
    var trackMilesDiff: Int
}

struct ITrackFlownFlightModel: Codable {
    var name: String
    var lat: String
    var long: String
}

struct ITrackFlownModel: Decodable {
    var flights3: [ITrackFlownFlightModel]
    var flights2: [ITrackFlownFlightModel]
    var flights1: [ITrackFlownFlightModel]
}

// EnrWX
struct ITrackMileEnrWXSubModel: Codable {
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
struct IFlvlFlight3SubModel: Codable {
    var waypoint: String
    var condition: String
    var flightLevel: Int
}

struct IFlvlFlight3Model: Codable {
    var flightLevels: [IFlvlFlight3SubModel]
    var aveDiff: Int
}

struct IFlightLevelModel: Codable {
    var flights3: IFlvlFlight3Model
    var week1: IFlvlFlight3Model
    var months3: IFlvlFlight3Model
}

//Reciprocal RWY
struct IReciprocalRwyModel: Codable {
    var trackMiles: [ITrackMileEnrWXSubModel]
    var aveNM: Int
    var aveMINS: Int
}

struct IFuelDataModel: Codable {
    let taxi: ITaxiModel
    let flightLevel: IFlightLevelModel
    let trackFlown: [String: [ITrackFlownFlightModel]]
    let historicalDelays: IHistoricalDelaysModel
    let projDelays: IProjDelaysModel
}

struct IDepMetarTafWXChild: Decodable {
    let airport: String
    let std: String
    let metar: String
    let taf: String
}

struct IArrMetarTafWXChild: Decodable {
    let airport: String
    let sta: String
    let metar: String
    let taf: String
}

struct IAltnMetarTafWXChild: Decodable {
    let airport: String
    let eta: String
    let metar: String
    let taf: String
}

struct IEnrMetarTafWXChild: Decodable {
    let airport: String
    let eta: String
    let metar: String
    let taf: String
}

struct IMetarTafWXJson: Decodable {
    let depMetarTaf: IDepMetarTafWXChild
    let arrMetarTaf: IArrMetarTafWXChild
    let altnMetarTaf: [IAltnMetarTafWXChild]
    let enrMetarTaf: [IAltnMetarTafWXChild]
}

struct INotamWXChildJson: Decodable {
    let rank: String
    let date: String
    let notam: String
}

struct INotamWXChild: Decodable {
    let Airport: String
    let Runway: [INotamWXChildJson]
    let Taxiway: [INotamWXChildJson]
    let Approach_Departure: [INotamWXChildJson]
    let Obstacles: [INotamWXChildJson]
    let Others: [INotamWXChildJson]
}

struct INotamWXAirportChild: Decodable {
    let Airport: String
    let eta: String
}

struct INotamWXChild2: Decodable {
    let Airport: INotamWXAirportChild
    let Runway: [INotamWXChildJson]
    let Taxiway: [INotamWXChildJson]
    let Approach_Departure: [INotamWXChildJson]
    let Obstacles: [INotamWXChildJson]
    let Others: [INotamWXChildJson]
}

struct INotamWXJson: Decodable {
    let depNotams: INotamWXChild
    let arrNotams: INotamWXChild
    let enrNotams: [INotamWXChild2]
    let altnNotams: [INotamWXChild2]
}

struct INotamWXDataJson: Decodable {
    let metarTafData: IMetarTafWXJson
    let notamsData: INotamWXJson
}


// For v3.0

struct FlightOverviewV30Json: Codable {
    let CAName: String
    let CAPicker: String
    let ETA: String
    let FOName: String
    let FOPicker: String
    let aircraft: String
    let blockTime: String
    let blockTime_FlightTime: String
    let callsign: String
    let chockOff: String
    let chockOn: String
    let day: String
    let dep: String
    let dest: String
    let flightTime: String
    let model: String
    let night: String
    let password: String
    let pob: String
    let sta: String
    let std: String
    let time_diff_arr: String
    let time_diff_dep: String
    let totalTime: String
}

struct RouteV30Json: Codable {
    let lat: String
    let long: String
    let name: String
}

struct ColorAirportV30Json: Codable {
    let airportID: String
    let colour: String
    let lat: String
    let long: String
    let metar: String
    let notams: [String]
    let selection: String
    let taf: String
}

struct NotamV30Json: Codable {
    let category: String
    let date: String
    let id: String
    let isChecked: Bool
    let notam: String
    let rank: String
    let type: String
}

struct MetarTafV30Json: Codable {
    let airportText: String
    let metar: String
    let taf: String
}

struct NotesV30Json: Codable {
    let canDelete: Bool
    let createdAt: String
    let favourite: Bool
    let fromParent: Bool
    let includeCrew: Bool
    let isDefault: Bool
    let name: String
    let parentId: String
    let tags: [String]
    let type: String
}

struct FlightDataV30Json: Codable {
    let status: String
    let flight_overview: FlightOverviewV30Json
    let route: [RouteV30Json]?
    let colour_airport: [IAirportColor]?
    let notam: [String: [NotamV30Json]]?
    let metar_taf: [String: [MetarTafV30Json]]?
    let notes: [NotesV30Json]?
    let aabba_notes: [String: [INoteResponse]]?
}

class YourFlightPlanModel: ObservableObject {
    @Published var selectedEvent: EventList?
    @Published var isActive = false
}

struct SectorDataJson: Codable {
    let depLat: String
    let depLong: String
    let dep_time_diff: String
    let dep_sunrise_time: String
    let dep_sunset_time: String
    let dep_next_sunrise_time: String
    let arrLat: String
    let arrLong: String
    let arr_time_diff: String
    let arr_sunrise_time: String
    let arr_sunset_time: String
    let arr_next_sunrise_time: String
}

struct UserProfileDataJson: Codable {
    let username: String
    let email: String
    let firstname: String
    let lastname: String
    let airline: String
}
