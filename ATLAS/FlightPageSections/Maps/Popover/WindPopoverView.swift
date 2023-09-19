//
//  WindPopoverView.swift
//  ATLAS
//
//  Created by phuong phan on 17/09/2023.
//

import SwiftUI

struct WindPopoverView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @Binding var isShowing: Bool
    @State var selectedStation: AirportMapColorList?
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(Font.custom("SF Pro", size: 15).weight(.regular)).foregroundColor(Color.theme.azure)
                }
                Spacer()
                
                Text("Wind").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.black)
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.theme.azure)
                }.opacity(0)
            }.background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            Picker("", selection: $selectedStation) {
                Text("Select Station").tag("")
                ForEach(coreDataModel.dataAirportColorMap, id: \.self) {
                    Text($0.airportId ?? "").tag($0 as AirportMapColorList?)
                }
            }.pickerStyle(MenuPickerStyle())
                .padding(.leading, -12)
            
            HStack {
                Text("Gusty")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    if validate() {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let newPost = AabbaPostList(context: persistenceController.container.viewContext)
                        newPost.id = UUID()
                        newPost.postId = ""
                        newPost.userId = "abc122" // Todo: Change to user login
                        newPost.postDate = dateFormatter.string(from: Date())
                        newPost.postTitle = "Runway wind"
                        newPost.postText = "Gusty"
                        newPost.upvoteCount = "0"
                        newPost.commentCount = "0"
                        newPost.category = "Wind"
                        newPost.location = selectedStation?.airportId
                        newPost.postUpdated = Date()
                        newPost.comments = NSSet(array: [AabbaCommentList]())
                        coreDataModel.save()

                        isShowing = false
                    }
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(validate() ? Color.theme.azure : Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
                    .cornerRadius(12)
            }.frame(maxWidth: .infinity)
            
            Divider().padding(.horizontal, -16)
            
            HStack {
                Text("Tailwinds")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    if validate() {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let newPost = AabbaPostList(context: persistenceController.container.viewContext)
                        newPost.id = UUID()
                        newPost.postId = ""
                        newPost.userId = "abc122" // Todo: Change to user login
                        newPost.postDate = dateFormatter.string(from: Date())
                        newPost.postTitle = "Runway wind"
                        newPost.postText = "Tailwinds"
                        newPost.upvoteCount = "0"
                        newPost.commentCount = "0"
                        newPost.category = "Wind"
                        newPost.location = selectedStation?.airportId
                        newPost.postUpdated = Date()
                        newPost.comments = NSSet(array: [AabbaCommentList]())
                        coreDataModel.save()

                        isShowing = false
                    }
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(validate() ? Color.theme.azure : Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
                    .cornerRadius(12)
            }.frame(maxWidth: .infinity)
            
            Divider().padding(.horizontal, -16)
            
            HStack {
                Text("Cross-tail")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    if validate() {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let newPost = AabbaPostList(context: persistenceController.container.viewContext)
                        newPost.id = UUID()
                        newPost.postId = ""
                        newPost.userId = "abc122" // Todo: Change to user login
                        newPost.postDate = dateFormatter.string(from: Date())
                        newPost.postTitle = "Runway wind"
                        newPost.postText = "Cross-tail"
                        newPost.upvoteCount = "0"
                        newPost.commentCount = "0"
                        newPost.category = "Wind"
                        newPost.location = selectedStation?.airportId
                        newPost.postUpdated = Date()
                        newPost.comments = NSSet(array: [AabbaCommentList]())
                        coreDataModel.save()

                        isShowing = false
                    }
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(validate() ? Color.theme.azure : Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
                    .cornerRadius(12)
            }.frame(maxWidth: .infinity)
            
            Divider().padding(.horizontal, -16)
            
            HStack {
                Text("Updrafts")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    if validate() {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let newPost = AabbaPostList(context: persistenceController.container.viewContext)
                        newPost.id = UUID()
                        newPost.postId = ""
                        newPost.userId = "abc122" // Todo: Change to user login
                        newPost.postDate = dateFormatter.string(from: Date())
                        newPost.postTitle = "Runway wind"
                        newPost.postText = "Updrafts"
                        newPost.upvoteCount = "0"
                        newPost.commentCount = "0"
                        newPost.category = "Wind"
                        newPost.location = selectedStation?.airportId
                        newPost.postUpdated = Date()
                        newPost.comments = NSSet(array: [AabbaCommentList]())
                        coreDataModel.save()

                        isShowing = false
                    }
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(validate() ? Color.theme.azure : Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
                    .cornerRadius(12)
            }.frame(maxWidth: .infinity)
            
        }.padding()
    }
    
    func validate() -> Bool {
        if selectedStation != nil {
            return true
        }
        return false
    }
}
