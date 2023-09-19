//
//  MapCardView.swift
//  ATLAS
//
//  Created by phuong phan on 14/09/2023.
//

import SwiftUI
import MapKit

struct CardTextField: View {
    let index: Int
    @State private var tfText = ""
    
    var body: some View {
        TextField("Enter Text", text: $tfText)
            .padding(8)
            .background(Color.theme.antiFlashWhite)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.arsenic.opacity(0.36), lineWidth: 0))
    }
}

struct MapCardView: View {
    var payload: AabbaMapList?
    var parentAabbaIndex: Int
    
    @State var parentIndex: Int = 0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack {
                        Text(payload?.name ?? "").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            //todo
                        }, label: {
                            HStack {
                                Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold))
                                    .foregroundColor(Color.theme.azure)
                            }.contentShape(Rectangle())
                        })
                    }
                    
                }.background(Color.white.opacity(0.75))
                    .roundedCorner(14, corners: [.topLeft, .topRight])
                
                if let posts = payload?.posts?.allObjects as? [AabbaPostList] {
                    MapPostView(posts: posts, parentIndex: $parentIndex)
                }
            }.frame(width: 360)
                .background(.regularMaterial)
        }.frame(maxHeight: 448)
            .onAppear {
                parentIndex = parentAabbaIndex
            }
    }
}
