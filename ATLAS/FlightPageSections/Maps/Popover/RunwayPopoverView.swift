//
//  RunwayPopoverView.swift
//  ATLAS
//
//  Created by phuong phan on 17/09/2023.
//

import SwiftUI

struct RunwayPopoverView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var remoteService: RemoteService
    @EnvironmentObject var mapIconModel: MapIconModel
    
    @AppStorage("uid") var userID: String = ""
    
    @Binding var isShowing: Bool
    @State var selectedStation: AirportMapColorList?
    @State var isUpdating = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(Font.custom("SF Pro", size: 15).weight(.regular)).foregroundColor(Color.theme.azure)
                }
                
                Spacer()
                
                Text("Runway").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.black)
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.theme.azure)
                }.opacity(0)
            }.background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            Picker("", selection: $selectedStation) {
                Text("Select Station").tag("").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                ForEach(coreDataModel.dataAirportColorMap, id: \.self) {
                    Text($0.airportId ?? "").tag($0 as AirportMapColorList?)
                }
            }.pickerStyle(MenuPickerStyle())
                .padding(.leading, -12)
            
            HStack {
                Text("Dry")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    if validate(), let airportId = selectedStation?.airportId {
                        let dataExist = coreDataModel.findOneAabba(name: airportId)
                        
                        if dataExist != nil {
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let newPost = AabbaPostList(context: persistenceController.container.viewContext)
                            newPost.id = UUID()
                            newPost.postId = UUID().uuidString
                            newPost.userId = userID
                            newPost.postDate = dateFormatter.string(from: Date())
                            newPost.postTitle = "Runway condition"
                            newPost.postText = "Dry"
                            newPost.upvoteCount = 0
                            newPost.commentCount = "0"
                            newPost.category = "Runway"
                            newPost.location = selectedStation?.airportId
                            newPost.postUpdated = Date()
                            newPost.comments = NSSet(array: [AabbaCommentList]())
                            
                            if let oldPosts = dataExist?.posts?.allObjects as? [AabbaPostList] {
                                dataExist?.postCount = "\((dataExist?.postCount as? NSString)!.integerValue + 1)"
                                dataExist?.posts = NSSet(array: oldPosts + [newPost])
                            }
                            
                            coreDataModel.save()
                            mapIconModel.numAabba += 1
                            isShowing = false
                        }
                    }
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(validate() ? Color.theme.azure : Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
            }.frame(maxWidth: .infinity)
            
            HStack {
                Text("Damp")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    if validate(), let airportId = selectedStation?.airportId {
                        let dataExist = coreDataModel.findOneAabba(name: airportId)
                        
                        if dataExist != nil {
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let newPost = AabbaPostList(context: persistenceController.container.viewContext)
                            newPost.id = UUID()
                            newPost.postId = UUID().uuidString
                            newPost.userId = userID
                            newPost.postDate = dateFormatter.string(from: Date())
                            newPost.postTitle = "Runway condition"
                            newPost.postText = "Damp"
                            newPost.upvoteCount = 0
                            newPost.commentCount = "0"
                            newPost.category = "Runway"
                            newPost.location = selectedStation?.airportId
                            newPost.postUpdated = Date()
                            newPost.comments = NSSet(array: [AabbaCommentList]())
                            
                            if let oldPosts = dataExist?.posts?.allObjects as? [AabbaPostList] {
                                dataExist?.postCount = "\((dataExist?.postCount as? NSString)!.integerValue + 1)"
                                dataExist?.posts = NSSet(array: oldPosts + [newPost])
                            }
                            
                            coreDataModel.save()
                            mapIconModel.numAabba += 1
                            isShowing = false
                        }
                    }
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(validate() ? Color.theme.azure : Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
            }.frame(maxWidth: .infinity)
            
            HStack {
                Text("Wet")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    if validate(), let airportId = selectedStation?.airportId {
                        let dataExist = coreDataModel.findOneAabba(name: airportId)
                        
                        if dataExist != nil {
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let newPost = AabbaPostList(context: persistenceController.container.viewContext)
                            newPost.id = UUID()
                            newPost.postId = UUID().uuidString
                            newPost.userId = userID
                            newPost.postDate = dateFormatter.string(from: Date())
                            newPost.postTitle = "Runway condition"
                            newPost.postText = "Wet"
                            newPost.upvoteCount = 0
                            newPost.commentCount = "0"
                            newPost.category = "Runway"
                            newPost.location = selectedStation?.airportId
                            newPost.postUpdated = Date()
                            newPost.comments = NSSet(array: [AabbaCommentList]())
                            
                            if let oldPosts = dataExist?.posts?.allObjects as? [AabbaPostList] {
                                dataExist?.postCount = "\((dataExist?.postCount as? NSString)!.integerValue + 1)"
                                dataExist?.posts = NSSet(array: oldPosts + [newPost])
                            }
                            
                            coreDataModel.save()
                            mapIconModel.numAabba += 1
                            isShowing = false
                        }
                    }
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(validate() ? Color.theme.azure : Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
            }.frame(maxWidth: .infinity)
            
            HStack {
                Text("Slippery")
                    .foregroundColor(Color.black)
                    .font(.system(size: 15))
                    .frame(height: 44)
                
                Spacer()
                
                Button(action: {
                    if validate(), let airportId = selectedStation?.airportId {
                        Task {
                            let dataExist = coreDataModel.findOneAabba(name: airportId)
                            
                            if dataExist != nil {
                                isUpdating = true
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                
                                let postCount = "\((dataExist?.postCount as? NSString)!.integerValue + 1)"
                                let postDate = dateFormatter.string(from: Date())
                                
                                let payloadPosts: [String: Any] = [
                                    "post_id": UUID().uuidString,
                                    "user_id": userID,
                                    "post_date": postDate,
                                    "post_title": "Runway condition",
                                    "post_text": "Slippery",
                                    "upvote_count": "0",
                                    "comment_count": "0",
                                    "category": "Weather",
                                    "comments": [String](),
                                    "username": "Nasrun360",
                                    "location": dataExist?.unwrappedName ?? ""
                                ]
                                
                                let payloadPost: [String: Any] = [
                                    "name": dataExist?.unwrappedName ?? "",
                                    "lat": dataExist?.unwrappedLatitude ?? "",
                                    "long": dataExist?.unwrappedLongitude ?? "",
                                    "post_count": postCount,
                                    "posts": [payloadPosts]
                                ]
                                
                                let payload = ["aabba_data": [payloadPost]]
                                
                                await remoteService.updateMapData(payload, completion: { success in
                                    if(success) {
                                        let newPost = AabbaPostList(context: persistenceController.container.viewContext)
                                        newPost.id = UUID()
                                        newPost.postId = UUID().uuidString
                                        newPost.userId = userID
                                        newPost.postDate = postDate
                                        newPost.postTitle = "Runway condition"
                                        newPost.postText = "Slippery"
                                        newPost.upvoteCount = 0
                                        newPost.commentCount = "0"
                                        newPost.category = "Runway"
                                        newPost.location = selectedStation?.airportId
                                        newPost.postUpdated = Date()
                                        newPost.comments = NSSet(array: [AabbaCommentList]())
                                        
                                        if let oldPosts = dataExist?.posts?.allObjects as? [AabbaPostList] {
                                            dataExist?.postCount = postCount
                                            dataExist?.posts = NSSet(array: oldPosts + [newPost])
                                        }
                                        
                                        coreDataModel.save()
                                        mapIconModel.numAabba += 1
                                        isShowing = false
                                    }
                                    
                                    isUpdating = false
                                })
                                
                            }
                        }
                    }
                }, label: {
                    Text("Post").font(.system(size: 15, weight: .regular)).foregroundColor(Color.white)
                }).padding(.vertical, 4)
                    .padding(.horizontal, 24)
                    .background(validate() ? Color.theme.azure : Color.theme.philippineGray3)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
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
