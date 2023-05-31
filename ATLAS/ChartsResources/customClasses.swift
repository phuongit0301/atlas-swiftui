//
//  customClasses.swift
//  ATLAS
//
//  Created by Muhammad Adil on 17/5/23.
//

import Foundation
import SwiftUI

/**
 A view useful for determining if a child view should act like it is horizontally compressed.
 
 Several elements are used to decide if a view is compressed:
 - Width
 - Dynamic Type size
 - Horizontal size class (on iOS)
 */
struct WidthThresholdReader<Content: View>: View {
    var widthThreshold: Double = 400
    var dynamicTypeThreshold: DynamicTypeSize = .xxLarge
    @ViewBuilder var content: (WidthThresholdProxy) -> Content
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif
    @Environment(\.dynamicTypeSize) private var dynamicType
    
    var body: some View {
        GeometryReader { geometryProxy in
            let compressionProxy = WidthThresholdProxy(
                width: geometryProxy.size.width,
                isCompact: isCompact(width: geometryProxy.size.width)
            )
            content(compressionProxy)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
                
    func isCompact(width: Double) -> Bool {
        #if os(iOS)
        if sizeClass == .compact {
            return true
        }
        #endif
        if dynamicType >= dynamicTypeThreshold {
            return true
        }
        if width < widthThreshold {
            return true
        }
        return false
    }
}

struct WidthThresholdProxy: Equatable {
    var width: Double
    var isCompact: Bool
}

struct WidthThresholdReader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            WidthThresholdReader { proxy in
                Label {
                    Text("Standard")
                } icon: {
                    compactIndicator(proxy: proxy)
                }
            }
            .border(.quaternary)
            
            WidthThresholdReader { proxy in
                Label {
                    Text("200 Wide")
                } icon: {
                    compactIndicator(proxy: proxy)
                }
            }
            .frame(width: 200)
            .border(.quaternary)
            
            WidthThresholdReader { proxy in
                Label {
                    Text("X Large Type")
                } icon: {
                    compactIndicator(proxy: proxy)
                }
            }
            .dynamicTypeSize(.xxxLarge)
            .border(.quaternary)
        
            #if os(iOS)
            WidthThresholdReader { proxy in
                Label {
                    Text("Manually Compact Size Class")
                } icon: {
                    compactIndicator(proxy: proxy)
                }
            }
            .border(.quaternary)
            .environment(\.horizontalSizeClass, .regular)
            #endif
        }
    }
    
    @ViewBuilder
    static func compactIndicator(proxy: WidthThresholdProxy) -> some View {
        if proxy.isCompact {
            Image(systemName: "arrowtriangle.right.and.line.vertical.and.arrowtriangle.left.fill")
                .foregroundStyle(.red)
        } else {
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.secondary)
        }
    }
}

public enum delayTimeframe: String, Hashable, CaseIterable, Sendable {
    case days
    case week
    case months
}

public enum taxiTimeframe: String, Hashable, CaseIterable, Sendable {
    case threeFlights
    case week
    case months
}

public enum trackMilesTimeframe: String, Hashable, CaseIterable, Sendable {
    case threeFlights
    case week
    case months
}

public enum flightLevelTimeframe: String, Hashable, CaseIterable, Sendable {
    case threeFlights
    case week
    case months
}

public enum enrWXTimeframe: String, Hashable, CaseIterable, Sendable {
    case threeFlights
    case week
    case months
}

func parseTimeString(_ dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    return dateFormatter.date(from: dateString)
}

func parseDateString(_ dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM"
    return dateFormatter.date(from: dateString)
}



class GlobalResponse: ObservableObject {
    @Published var response: String = ""
    
    static let shared = GlobalResponse()
    private init() {}
}

class APIManager: ObservableObject {
    static let shared = APIManager()
    private let globalResponse = GlobalResponse.shared

    private init() {}

    func makePostRequest(completion: @escaping (String?) -> Void = { _ in }) async {
        guard let url = URL(string: "https://accumulus-backend-atlas-lvketaariq-et.a.run.app/ATLAS_get_fuel_data") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the request body data
        let requestBody = [
            "airline": "accumulus air",
            "fltno": "EK352",
            "eta": "18:00",
            "arr": "SIN",
            "dep": "DXB"
        ]
        print(requestBody)
        do {
            // Convert the request body to JSON data
            let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            // Set the request body data
            request.httpBody = requestData
            
            // Set the Content-Type header to indicate JSON format
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            if let responseString = String(data: data, encoding: .utf8) {
                // to deal with API response as a string
                //let trimmedString = responseString.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                DispatchQueue.main.async {
                    self.globalResponse.response = responseString
                    //print("responseString: \(responseString)")
                }
                completion(responseString)
                print("fetched")
            } else {
                completion(nil)
            }
        } catch {
            print("Error: \(error)")
            completion(nil)
        }
    }
}

