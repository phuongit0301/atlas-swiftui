//
//  fetchFlightPlanData.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/6/23.
//

import Foundation

// fetch flight plan data - todo replace with API / core data
func fetchFlightPlanData() -> [String: Any] {
    let infoData = InfoData(planNo: "20", fltNo: "SQ123", tailNo: "9VSHM", dep: "SIN", dest: "BER", depICAO: "WSSS", destICAO: "EDDB", flightDate: "040723", STDUTC: "04 08:00", STAUTC: "04 17:00", STDLocal: "04 10:00", STALocal: "04 21:00", BLKTime: "09:00", FLTTime: "08:45")
    
    let routeData = RouteData(routeNo: "SINBER91", route: "WSSS/20L AKOMA DCT AKMET DCT AROSO Y513 KALIL Y504 BILIK G582 PUGER P574 UDULO P574 TOTOX L555 TOLDA M628 PEKEM M628 MIGMA M550 MEVDO  Y511 PMA V22 YEN L300 LXR P751 KATAB B12 DBA L613 TANSA UL617 KEA UG33 KOROS UN133 PEREN UL863 EVIVI DCT OKANA DCT TONDO DCT BEGLA DCT LOKVU DCT LEGAZ DCT BEFRE T204 TEXTI T204 NUKRO DCT EDDB/25L", depRwy: "WSSS/20L", arrRwy: "EDDB/25L", levels: "SIN/360/UDULO/380/PEKEM/390/MIGMA/400/KEA/410/KOROS/430/TEXTI/380")
    
    let perfData = PerfData(fltRules: "RVSM", gndMiles: "6385", airMiles: "7004", crzComp: "M42", apd: "1.4", ci: "100", zfwChange: "557", lvlChange: "500", planZFW: "143416", maxZFW: "161025", limZFW: "Structural", planTOW: "227883", maxTOW: "227930", limTOW: "Perf - Obstacle", planLDW: "151726", maxLDW: "172365", limLDW: "Structural")
    
    let fuelData = FuelData(burnoff: ["time": "14:21", "fuel": "076157", "unit": "100"], cont: ["time": "00:34", "fuel": "003000", "policy": "5%"], altn: ["time": "00:42", "fuel": "003279", "unit": "100"], hold: ["time": "00:30", "fuel": "002031", "unit": "100"], topup60: ["time": "00:00", "fuel": "000000"], taxi: ["time": "N.A", "fuel": "000500", "policy": "7mins std taxi time", "unit": "100"], planReq: ["time": "16:07", "fuel": "084967"], dispAdd: ["time": "00:10", "fuel": "000600", "policy": "PER COMPANY POLICY FOR SINBER FLIGHTS"])
    
    let altnData = [
        AltnData(altnRwy: "EDDH/15", rte: "EDDB SOGMA1N SOGMA M748 RARUP T909 HAM DCT", vis: "1600", minima: "670", dist: "0190", fl: "220", comp: "M015", time: "0042", fuel: "03279"),
        AltnData(altnRwy: "EDDK/32R", rte: "EDDB ODLUN1N ODLUN DCT ORTAG DCT ERSIL Y221 EBANA T841 ERNEP ERNEP1C", vis: "1600", minima: "800", dist: "0270", fl: "280", comp: "M017", time: "0055", fuel: "04269"),
        AltnData(altnRwy: "EDDL/05L", rte: "EDDB POVEL1N POVEL DCT EXOBA DCT HMM T851 HALME HALME1X", vis: "1600", minima: "550", dist: "0301", fl: "320", comp: "M018", time: "0057", fuel: "04512"),
        AltnData(altnRwy: "EDDF/25L", rte: "EDDB ODLUN1N ODLUN DCT ORTAG DCT ERSIL Y222 FUL T152 KERAX KERAX3A", vis: "1600", minima: "940", dist: "0246", fl: "280", comp: "M014", time: "0049", fuel: "03914")
        ]
    
    let atcFlightPlanData = """
    -B788/H-SSDDE1E1E2E2E3E3GGHHIIJ3J3J4J4J5J5J6J6M1M1P2P2RRWWXXYYZZ/LLB
    
    -WSSS1740
    
    -N0500F360 AKOMA DCT AKMET DCT AROSO Y513 KALIL Y504 BILIK/M085F360 G582 PUGER P574 UDULO/M085F380 P574 TOTOX/N0497F380 L555 TOLDA M628 PEKEM/N0494F390 M628 MIGMA/N0491F400 M550 MEVDO Y511 PMA V22 YEN L300 LXR P751 KATAB B12 DBA L613 TANSA UL617 KEA/N0494F410 UG33 KOROS/N0491F430 UN133 PEREN UL863 EVIVI DCT OKANA DCT TONDO DCT BEGLA DCT LOKVU DCT LEGAZ DCT BEFRE T204 TEXTI/N0495F380 T204 NUKRO DCT
    
    -EDDB1421 EDDH
    
    -PBN/A1A1B1B1C1C1D1D1L1L1O1O1S2S2 NAV/RNP2,RNP2 DAT/CPDLCX,CPDLCX SUR/RSP180,RSP180 DOF/211202 REG/9VOFH EET/WMFC0001 WIIF0037 WMFC0116 VOMF0125 VABF0412 OOMM0549 OMAE0646 OEJD0657 HECC0923 LGGG1118 LBSR1223 LYBA1236 LHCC1307 LOVV1325 LKAA1335 EDUU1352 EDWW1404 SEL/FJAQ CODE/76BCC8 OPR/TGW 65 66922602 PER/D RMK/ACASII EQUIPPED CALLSIGN SCOOTER TCAS OMAN PERMIT DATOFTGW00092021 SAUDI PERMIT 202160995TA EGYPT PERMIT CAD569817OCT21
    """
    
    let waypointsData = [
        waypoints(posn: "A", actm: "somestring", ztm: "00:05", eta: "0130", ata: "0135", afl: "220", oat: "M59", adn: "somestring", aWind: "25015", tas: "somestring", vws: "somestring", zfrq: "0.3", afrm: "086.9", Cord: "somestring", Msa: "somestring", Dis: "somestring", Diff: "somestring", Pfl: "somestring", Imt: "somestring", Pdn: "somestring", fWind: "somestring", Gsp: "somestring", Drm: "somestring", Pfrm: "086.9", fDiff: "somestring"),
        waypoints(posn: "B", actm: "somestring", ztm: "00:02", eta: "0135", ata: "0140", afl: "230", oat: "M60", adn: "somestring", aWind: "26527", tas: "somestring", vws: "7", zfrq: "0.2", afrm: "086.6", Cord: "somestring", Msa: "100*", Dis: "somestring", Diff: "somestring", Pfl: "somestring", Imt: "somestring", Pdn: "somestring", fWind: "somestring", Gsp: "somestring", Drm: "somestring", Pfrm: "086.6", fDiff: "somestring"),
        waypoints(posn: "C", actm: "somestring", ztm: "00:03", eta: "0140", ata: "0145", afl: "240", oat: "M61", adn: "somestring", aWind: "27018", tas: "somestring", vws: "somestring", zfrq: "0.4", afrm: "086.3", Cord: "somestring", Msa: "70", Dis: "somestring", Diff: "somestring", Pfl: "somestring", Imt: "somestring", Pdn: "somestring", fWind: "somestring", Gsp: "somestring", Drm: "somestring", Pfrm: "086.3", fDiff: "somestring"),
        waypoints(posn: "D", actm: "somestring", ztm: "00:01", eta: "0145", ata: "0150", afl: "250", oat: "M62", adn: "somestring", aWind: "28019", tas: "somestring", vws: "3", zfrq: "0.5", afrm: "086.2", Cord: "somestring", Msa: "somestring", Dis: "somestring", Diff: "somestring", Pfl: "somestring", Imt: "somestring", Pdn: "somestring", fWind: "somestring", Gsp: "somestring", Drm: "somestring", Pfrm: "086.2", fDiff: "somestring")
    ]
    
    let notamsData = NotamsData(depNotams: ["""
                                A1333/23 NOTAMN
                                Q) WSJC/QMXLC/IV/BO/A/000/999/0122N10359E005
                                A) WSSS B) 2306161700 C) 2306292100
                                D) JUN 16 17 20 22 23 24 27 29 1700-2100
                                E) FLW TWY CLSD DUE TO WIP:
                                1) TWY J BTN TWY T AND TWY J12, INCLUDING JUNCTION OF TWY J/TWY J12
                                AND JUNCTION OF TWY J/TWY B
                                2) TWY K BTN TWY T AND TWY J12, INCLUDING JUNCTION OF TWY K/TWY J12
                                AND JUNCTION OF TWY K/TWY B
                                3) TWY K1, TWY K2 AND TWY K3
                                """], enrNotams: ["""
                                B0157/23
                                Q) EDXX/QAFXX/IV/NBO/E/000/999/5123N01019E262
                                A) EDWW  A) EDGG  A) EDMM  B) FROM: 23/02/28 14:29  TO: 23/05/25 23:59 EST
                                E) MILITARY INVASION OF UKRAINE BY RUSSIAN FEDERATION:

                                NOTE 1: ALL AIRCRAFT OWNED, CHARTERED OR OPERATED BY CITIZENS OF THE
                                RUSSIAN FEDERATION OR OTHERWISE CONTROLLED BY NATURAL OR LEGAL
                                PERSONS OR ENTITY FROM THE RUSSIAN FEDERATION AND OPERATORS HOLDING
                                AIR OPERATOR CERTIFICATE (AOC) ISSUED BY THE RUSSIAN FEDERATION
                                AUTHORITIES ARE PROHIBITED TO ENTER, EXIT OR OVERFLY GERMAN AIRSPACE
                                EXCEPT HUMANITARIAN FLIGHTS WITH THE PERMISSION OF THE GERMAN
                                MINISTRY FOR DIGITAL AND TRANSPORT AND IN CASE OF EMERGENCY LANDING
                                OR EMERGENCY OVERFLIGHT. REQUESTS FOR HUMANITARIAN FLIGHTS SHALL BE
                                SENT TO HUM-FLIGHTS(AT)DFS.DE WITH DATE, EOBT, ADEP AND ADES.
                                END PART 1 OF 2
                                """], arrNotams: ["""
                                A2143/23
                                Q) EDWW/QNVAS/IV/BO/AE/000/999/5225N01408E025
                                A) EDDB  B) FROM: 23/05/09 10:21  TO: 23/05/11 15:00 EST
                                E) FUERSTENWALDE VOR/DME FWE 113.30MHZ/CH80X, VOR PART OUT OF
                                SERVICE
                                """])
    
    let metarTafData = MetarTafData(depMetar: "METAR WSSS 161320Z AUTO 30011KT 9999 3100 -SHRA SCT026 BKN040 FEW///CB 17/13 Q1015 RESHRA TEMPO SHRA", depTaf: "TAF WSSS 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015", arrMetar: "METAR EDDB 161320Z AUTO 30011KT 9999 3100 -SHRA SCT026 BKN040 FEW///CB 17/13 Q1015 RESHRA TEMPO SHRA", arrTaf: "TAF EDDB 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015", altnTaf: [
        AltnTafData(altnRwy: "EDDH/15", eta: "1742", taf: "TAF EDDH 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015"),
        AltnTafData(altnRwy: "EDDK/32R", eta: "1755", taf: "TAF EDDK 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015"),
        AltnTafData(altnRwy: "EDDL/05L", eta: "1757", taf: "TAF EDDL 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015"),
        AltnTafData(altnRwy: "EDDF/25L", eta: "1749", taf: "TAF EDDF 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015")
    ])
    
    let object = ["infoData": infoData, "routeData": routeData, "perfData": perfData, "fuelData": fuelData, "altnData": altnData, "atcFlightPlanData": atcFlightPlanData, "waypointsData": waypointsData, "notamsData": notamsData, "metarTafData": metarTafData] as [String : Any]
    return object
}


struct InfoData: Codable {
    let planNo: String
    let fltNo: String
    let tailNo: String
    let dep: String
    let dest: String
    let depICAO: String
    let destICAO: String
    let flightDate: String
    let STDUTC: String
    let STAUTC: String
    let STDLocal: String
    let STALocal: String
    let BLKTime: String
    let FLTTime: String
}

struct RouteData: Codable {
    let routeNo: String
    let route: String
    let depRwy: String
    let arrRwy: String
    let levels: String
}

struct PerfData: Codable {
    let fltRules: String
    let gndMiles: String
    let airMiles: String
    let crzComp: String
    let apd: String
    let ci: String
    let zfwChange: String
    let lvlChange: String
    let planZFW: String
    let maxZFW: String
    let limZFW: String
    let planTOW: String
    let maxTOW: String
    let limTOW: String
    let planLDW: String
    let maxLDW: String
    let limLDW: String
}

struct FuelData: Codable {
    let burnoff: [String : String]
    let cont: [String : String]
    let altn: [String : String]
    let hold: [String : String]
    let topup60: [String : String]
    let taxi: [String : String]
    let planReq: [String : String]
    let dispAdd: [String : String]
}

struct AltnData: Codable {
    let altnRwy: String
    let rte: String
    let vis: String
    let minima: String
    let dist: String
    let fl: String
    let comp: String
    let time: String
    let fuel: String
}

struct NotamsData: Codable {
    let depNotams: [String]
    let enrNotams: [String]
    let arrNotams: [String]
}

struct MetarTafData: Codable {
    let depMetar: String
    let depTaf: String
    let arrMetar: String
    let arrTaf: String
    let altnTaf: [AltnTafData]
}

struct AltnTafData: Codable {
    let altnRwy: String
    let eta: String
    let taf: String
}
