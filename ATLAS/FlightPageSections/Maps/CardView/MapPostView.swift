//
//  MapPostView.swift
//  ATLAS
//
//  Created by phuong phan on 18/09/2023.
//

import SwiftUI

struct MapPostView: View {
    let posts: [AabbaPostList]
    @Binding var parentIndex: Int
    
    @State private var showModal = false
    @State private var postIndex = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(posts.indices) {index in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(posts[index].unwrappedCategory)
                            .font(Font.custom("SF Pro", size: 11))
                            .foregroundColor(Color.white)
                    }.padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(handleColor(posts[index].unwrappedCategory))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 0))
                    
                    Text(posts[index].unwrappedPostTitle)
                        .font(Font.custom("SF Pro", size: 15))
                        .foregroundColor(.black)
                    
                    HStack {
                        Text(posts[index].unwrappedUserName)
                            .font(Font.custom("SF Pro", size: 11))
                            .foregroundColor(Color.theme.azure)
                        Text("Posted \(posts[index].unwrappedPostDate)")
                            .font(Font.custom("SF Pro", size: 11))
                            .foregroundColor(Color.theme.arsenic.opacity(0.6))
                        
                    }
                    
                    Divider()
                    
                    HStack {
                        HStack {
                            Image("icon_arrowshape_up")
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                            
                            Text(posts[index].unwrappedUpvoteCount)
                                .font(Font.custom("SF Pro", size: 13).weight(.medium))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.postIndex = index
                            self.showModal.toggle()
                        }, label:  {
                            HStack {
                                Image(systemName: "bubble.left.and.bubble.right")
                                    .foregroundColor(Color.theme.azure)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                
                                if let comments = posts[index].comments {
                                    Text("\(comments.count)")
                                        .font(Font.custom("SF Pro", size: 13).weight(.medium))
                                        .foregroundColor(.black)
                                } else {
                                    Text("0")
                                        .font(Font.custom("SF Pro", size: 13).weight(.medium))
                                        .foregroundColor(.black)
                                }
                                
                            }
                        }).buttonStyle(PlainButtonStyle())
                    }
                    
                    // Get first comment and show
                    if (posts[index].unwrappedCommentCount as NSString).integerValue > 0 {
                        if let comments = posts[index].comments?.allObjects as? [AabbaCommentList], let firstComment = comments.first {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(firstComment.unwrappedUserName)
                                        .font(Font.custom("SF Pro", size: 11))
                                        .foregroundColor(Color.theme.azure)
                                    Text("Posted \(firstComment.unwrappedCommentDate)")
                                        .font(Font.custom("SF Pro", size: 11))
                                        .foregroundColor(Color.theme.arsenic.opacity(0.6))
                                }
                                Text(firstComment.unwrappedCommentText)
                                    .font(Font.custom("SF Pro", size: 13))
                                    .foregroundColor(Color.black)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .padding(8)
                                .background(Color.theme.antiFlashWhite)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.arsenic.opacity(0.36), lineWidth: 0))
                        }
                    }
                }.padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .background(Color.white)
            }
        }.sheet(isPresented: $showModal) {
            ModalCommentView(isShowing: $showModal, parentIndex: $parentIndex, postIndex: $postIndex).interactiveDismissDisabled(true)
        }
    }
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
