//
//  HomeViewSplit.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct HomeViewSplit: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderViewSplit()
            
            OverviewView()
                .tag(NavigationEnumeration.OverviewScreen)
                .frame(maxWidth: .infinity)
                .navigationBarBackButtonHidden()
        }.ignoresSafeArea()
    }
    
}

struct HomeViewSplit_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewSplit().environmentObject(SideMenuModelState())
    }
}
