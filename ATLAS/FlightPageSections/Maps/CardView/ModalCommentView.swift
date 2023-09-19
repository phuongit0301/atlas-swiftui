//
//  ModalCommentView.swift
//  ATLAS
//
//  Created by phuong phan on 18/09/2023.
//

import SwiftUI

struct ModalCommentView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @Binding var isShowing: Bool
    @Binding var parentIndex: Int
    @Binding var postIndex: Int
    
    @State private var posts: [AabbaPostList]?
    @State private var post: AabbaPostList?
    @State private var tfComment: String = ""
    let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(Font.custom("SF Pro", size: 15).weight(.regular)).foregroundColor(Color.theme.azure)
                }
                
                Spacer()
                
                Text("View and Add Comments").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.black)
                
                Spacer()
                
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.theme.azure)
                }
            }.padding()
                .background(.white)
                .overlay(Rectangle().inset(by: 0.17).stroke(.black.opacity(0.3), lineWidth: 0.33))
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            if let post = post {
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            HStack {
                                Text(post.unwrappedCategory)
                                    .font(Font.custom("SF Pro", size: 11))
                                    .foregroundColor(Color.white)
                            }.padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(handleColor(post.unwrappedCategory))
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 0))
                            
                            Text(post.unwrappedUserName)
                                .font(Font.custom("SF Pro", size: 11))
                                .foregroundColor(Color.theme.azure)
                            
                            Text("Posted \(post.unwrappedPostDate)")
                                .font(Font.custom("SF Pro", size: 11))
                                .foregroundColor(Color.theme.arsenic.opacity(0.6))
                        }
                        
                        Text(post.unwrappedPostTitle)
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.black)
                        
                        Divider()
                        
                        HStack {
                            HStack {
                                Image("icon_arrowshape_up")
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                
                                Text(post.unwrappedUpvoteCount)
                                    .font(Font.custom("SF Pro", size: 13).weight(.medium))
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "bubble.left.and.bubble.right")
                                    .foregroundColor(Color.theme.azure)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                
                                if let comments = post.comments {
                                    Text("\(comments.count)")
                                        .font(Font.custom("SF Pro", size: 13).weight(.medium))
                                        .foregroundColor(.black)
                                } else {
                                    Text("0")
                                        .font(Font.custom("SF Pro", size: 13).weight(.medium))
                                        .foregroundColor(.black)
                                }
                                
                            }
                            
                        }
                        
                        if let comments = post.comments?.allObjects as? [AabbaCommentList], comments.count > 0 {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(comments, id: \.self) {comment in
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                HStack {
                                                    Text(comment.unwrappedUserName)
                                                        .font(Font.custom("SF Pro", size: 11))
                                                        .foregroundColor(Color.theme.azure)
                                                    Text("Posted \(comment.unwrappedCommentDate)")
                                                        .font(Font.custom("SF Pro", size: 11))
                                                        .foregroundColor(Color.theme.arsenic.opacity(0.6))
                                                }
                                                Text(comment.unwrappedCommentText)
                                                    .font(Font.custom("SF Pro", size: 13))
                                                    .foregroundColor(Color.black)
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(8)
                                                .background(Color.theme.antiFlashWhite)
                                                .cornerRadius(8)
                                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.arsenic.opacity(0.36), lineWidth: 0))
                                            
                                            HStack {
                                                Image("icon_arrowshape_up")
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                
                                                Text(post.unwrappedUpvoteCount)
                                                    .font(Font.custom("SF Pro", size: 13).weight(.medium))
                                                    .foregroundColor(.black)
                                            }
                                            
                                            HStack {
                                                Image(systemName: "arrowshape.turn.up.left")
                                                    .foregroundColor(Color.theme.azure)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                
                                                Text("Reply")
                                                    .font(Font.custom("SF Pro", size: 13).weight(.regular))
                                                    .foregroundColor(.black)
                                            }
                                        }.padding(.bottom)
                                        
                                    }
                                } //End VStack
                            }.padding(8)
                        }
                        
                        Spacer()
                        
                        HStack {
                            TextField("Write a comment...", text: $tfComment)
                                .padding(8)
                                .background(Color.theme.antiFlashWhite)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.arsenic.opacity(0.36), lineWidth: 0))
                            
                            Button(action: {
                                if tfComment != "" {
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    
                                    let item = AabbaCommentList(context: persistenceController.container.viewContext)
                                    
                                    item.id = UUID()
                                    item.commentId = UUID().uuidString
                                    item.postId = "cdead350-d303-4000-ad9c-c2a50b0ab1b7"
                                    item.userId = "abc123"
                                    item.commentDate = dateFormatter.string(from: Date())
                                    item.commentText = tfComment.trimmingCharacters(in: .whitespacesAndNewlines)
                                    item.userName = "phuongpt"
                                    post.addToComments(item)
                                    
                                    coreDataModel.save()
                                    
                                    tfComment = ""
                                    coreDataModel.dataAabbaMap = coreDataModel.readDataAabbaMapList()
                                }
                            }, label: {
                                Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                            }).padding(.vertical, 4)
                                .padding(.horizontal, 24)
                                .background(tfComment == "" ? Color.theme.philippineGray3 : Color.theme.azure)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
                                .cornerRadius(12)
                        }.padding(.top, 16)
                    }//End VStack
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                
                }.padding(8)
                    .background(Color.theme.antiFlashWhite)
                
            }
            
            Spacer()
        }
        .onAppear {
            if coreDataModel.dataAabbaMap.count > 0 {
                if let payload = coreDataModel.dataAabbaMap[parentIndex].posts, let posts = payload.allObjects as? [AabbaPostList] {
                    self.posts = posts
                    self.post = posts[postIndex]
                }
            }
        }
    }
}
