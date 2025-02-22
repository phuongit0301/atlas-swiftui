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

struct MapTrafficCardView: View {
    var title: String?
    var aircraftType: String?
    var baroAltitude: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title ?? "").font(.system(size: 15).weight(.semibold)).foregroundColor(.black)
            Text(aircraftType ?? "").font(.system(size: 15).weight(.regular)).foregroundColor(.black)
            Text(baroAltitude ?? "").font(.system(size: 15).weight(.regular)).foregroundColor(.black)
        }
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
                        
//                        Button(action: {
//                            //todo
//                        }, label: {
//                            HStack {
//                                Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold))
//                                    .foregroundColor(Color.theme.azure)
//                            }.contentShape(Rectangle())
//                        })
                    }
                    
                }
                
                if let posts = payload?.posts?.allObjects as? [AabbaPostList] {
                    MapPostView(posts: posts, parentIndex: $parentIndex)
                }
            }.frame(width: 360)
                .background(.regularMaterial)
                .cornerRadius(8)
        }.frame(maxHeight: 400)
            .onAppear {
                parentIndex = parentAabbaIndex
            }
    }
}
