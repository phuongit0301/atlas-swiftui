//
//  MainView.swift
//  ATLAS
//
//  Created by phuong phan on 06/09/2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var modelState: MainTabModelState
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                GeometryReader { geo in
                    // Menu Top
                    VStack(alignment: .leading, spacing: 0) {
                        // Tabs
                        switch modelState.selectedTab.screenName {
                            case MainNavigationEnumeration.HomeSectionView:
                                HomeSectionView()
                                    .tag(MainNavigationEnumeration.HomeSectionView)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .toolbar(.hidden, for: .tabBar)
                                    .ignoresSafeArea()
                            case MainNavigationEnumeration.CalendarSectionView:
                                CalendarSectionView()
                                    .tag(MainNavigationEnumeration.CalendarSectionView)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .toolbar(.hidden, for: .tabBar)
                                    .ignoresSafeArea()
                            case MainNavigationEnumeration.LogbookSectionView:
                                RecencySectionView()
                                    .tag(MainNavigationEnumeration.LogbookSectionView)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .toolbar(.hidden, for: .tabBar)
                                    .ignoresSafeArea()
                            case MainNavigationEnumeration.RecencySectionView:
                                RecencySectionView()
                                    .tag(MainNavigationEnumeration.RecencySectionView)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.theme.cultured)
                                    .toolbar(.hidden, for: .tabBar)
                                    .ignoresSafeArea()

                            case MainNavigationEnumeration.AABBASectionView:
                                MapViewModal()
                                    .tag(MainNavigationEnumeration.AABBASectionView)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .toolbar(.hidden, for: .tabBar)
                                    .ignoresSafeArea()
                            case MainNavigationEnumeration.ChatSectionView:
                                ChatSectionView()
                                    .tag(MainNavigationEnumeration.ChatSectionView)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .toolbar(.hidden, for: .tabBar)
                                    .ignoresSafeArea()
                            default:
                                HomeSectionView()
                                    .tag(MainNavigationEnumeration.HomeSectionView)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .toolbar(.hidden, for: .tabBar)
                                    .ignoresSafeArea()

                            }

                    }
                    .hasMainTabbar()
                    .hasToolbar()
                }
                
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SideMenuModelState())
            .environmentObject(TabModelState())
    }
}
