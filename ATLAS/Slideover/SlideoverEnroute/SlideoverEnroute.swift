//
//  SlideoverEnroute.swift
//  ATLAS
//
//  Created by phuong phan on 29/09/2023.
//

import SwiftUI

struct SlideoverEnroute: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var refState: ScreenReferenceModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                HeaderViewSplit(isMenu: true)
                
                VStack(spacing: 0) {
                    
                    HStack(alignment: .center) {
                        HStack {
                            Text("Enroute").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                        }
                        Spacer()
                        
                    }.frame(height: 52)
                    // End header
                    ScrollView {
                        VStack(spacing: 8) {
                            SlideoverEnrouteNotamView(itemList: $viewModel.dataEnrouteNotamsRef)
                            SlideoverEnrouteNoteView(width: proxy.size.width)
                        }
                    }
                }.padding(.horizontal, 16)
            }.padding(.bottom, 32)
                .background(Color.theme.antiFlashWhite)
        }
    }
}
