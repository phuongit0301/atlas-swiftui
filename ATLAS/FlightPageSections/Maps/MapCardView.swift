//
//  MapCardView.swift
//  ATLAS
//
//  Created by phuong phan on 14/09/2023.
//

import SwiftUI

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
    var payload: IAabbaData?
    
    var body: some View {
        ScrollView(.vertical, showIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack {
                        Text(payload?.name ?? "").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            // Todo
                        }, label: {
                            Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold))
                                .foregroundColor(Color.theme.azure)
                        })
                    }
                    
                }.background(Color.white.opacity(0.75))
                    .roundedCorner(14, corners: [.topLeft, .topRight])
                
                if let posts = payload?.posts {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(posts.indices) {index in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(posts[index].category)
                                        .font(Font.custom("SF Pro", size: 11))
                                        .foregroundColor(Color.white)
                                }.padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(handleColor(posts[index].category))
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 0))
                                
                                Text(posts[index].post_title)
                                    .font(Font.custom("SF Pro", size: 15))
                                    .foregroundColor(.black)
                                
                                HStack {
                                    Text(posts[index].username)
                                        .font(Font.custom("SF Pro", size: 11))
                                        .foregroundColor(Color.theme.azure)
                                    Text("Posted \(posts[index].post_date)")
                                        .font(Font.custom("SF Pro", size: 11))
                                        .foregroundColor(Color.theme.arsenic.opacity(0.6))
                                    
                                }
                                
                                Divider()
                                
                                HStack {
                                    HStack {
                                        Image("icon_arrowshape_up")
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                        
                                        Text(posts[index].upvote_count)
                                            .font(Font.custom("SF Pro", size: 13).weight(.medium))
                                            .foregroundColor(.black)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Image(systemName: "bubble.left.and.bubble.right")
                                            .foregroundColor(Color.theme.azure)
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                        
                                        Text(posts[index].comment_count)
                                            .font(Font.custom("SF Pro", size: 13).weight(.medium))
                                            .foregroundColor(.black)
                                    }
                                }
                                
                                CardTextField(index: index)
                            }.padding(.horizontal, 8)
                                .padding(.vertical, 8)
                                .background(Color.white)
                        }
                    }
                }
            }.frame(width: 360)
                .background(.regularMaterial)
        }.frame(maxHeight: 448)
    }
    
    func handleColor(_ category: String) -> Color {
        var color = Color.theme.seaSerpent
        
        if category == "Turbulence" {
            color = Color.theme.coralRed1
        }
        
        if category == "Visibility" {
            color = Color.theme.tangerineYellow
        }
        
        if category == "Wind" {
            color = Color.theme.blueJeans
        }
        
        if category == "Runway" {
            color = Color.theme.vividGamboge
        }
        
        if category == "Congestion" {
            color = Color.theme.cafeAuLait
        }
        
        if category == "Hazard" {
            color = Color.theme.coralRed1
        }
        
        if category == "General" {
            color = Color.theme.iris
        }
        
        if category == "Ask AABBA" {
            color = Color.theme.mediumOrchid
        }
        
        return color
    }
}
