//
//  File.swift
//  ATLAS
//
//  Created by phuong phan on 28/05/2023.
//

import Foundation
import SwiftUI

struct BottomTabs: View {
    private var viewModel = BottomMenuModel()
    @State private var currentScreen = MainScreen.HomeScreen
    @State var selectedItem: BottomMenuItem? = nil
    @Environment(\.sceneSession) private var sceneSession: UISceneSession?
    
    var body: some View {
        // header list icons
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(viewModel.BottomMenu, id: \.self) { item in
                        VStack(spacing: 0) {
                            VStack(alignment: .center) {
                                Image(systemName: item.name)
                                    .frame(width: 16, height: 16)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }.frame(width: 32, height: 32, alignment: .center).padding().background(Color.theme.aeroBlue).cornerRadius(12)
                        }.onTapGesture {
                            withAnimation(.easeInOut) {
                                if item.isExternal {
                                    if let url = URL(string: "App-Prefs://root=NOTES") {
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }
                                    }
                                    
//                                    let userActivity = NSUserActivity(
//                                        activityType: "com.external.notes"
//                                    )
//                                    userActivity.targetContentIdentifier =
//                                    "com.external.notes"
//                                    
//                                    UIApplication.shared.requestSceneSessionActivation(
//                                        nil,
//                                        userActivity: userActivity,
//                                        options: nil,
//                                        errorHandler: nil
//                                    )
                                } else {
                                    let userActivity = NSUserActivity(
                                        activityType: "sg.accumulus.ios.book-flight"
                                    )
                                    userActivity.targetContentIdentifier =
                                    "sg.accumulus.ios.book-flight"
                                    
                                    UIApplication.shared.requestSceneSessionActivation(
                                        nil,
                                        userActivity: userActivity,
                                        options: nil,
                                        errorHandler: nil
                                    )
                                }
                            }
                        }
                }.padding(12)
            }
        }
    }
}
