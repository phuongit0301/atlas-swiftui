//
//  VisibilityPopoverView.swift
//  ATLAS
//
//  Created by phuong phan on 17/09/2023.
//

import SwiftUI

struct VisibilityPopoverView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var mapIconModel: MapIconModel
    
    @Binding var isShowing: Bool
    @State var selectedStation: AirportMapColorList?
    @State var selectedRunway = 1
    
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
                
                Text("Visibility").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.black)
                
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
                Text("Runway sighted at").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                
                Spacer()
                
                Picker("", selection: $selectedRunway) {
                    ForEach(1 ..< 11, id: \.self) {
                        Text("\($0)nm").tag($0)
                    }
                }.pickerStyle(MenuPickerStyle())
                
                Button(action: {
                    if validate(), let airportId = selectedStation?.airportId {
                        let dataExist = coreDataModel.findOneAabba(name: airportId)
                        
                        if dataExist != nil {
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let newPost = AabbaPostList(context: persistenceController.container.viewContext)
                            newPost.id = UUID()
                            newPost.postId = ""
                            newPost.userId = "abc122" // Todo: Change to user login
                            newPost.postDate = dateFormatter.string(from: Date())
                            newPost.postTitle = "Runway Visibility"
                            newPost.postText = "\(selectedRunway)nm"
                            newPost.upvoteCount = "0"
                            newPost.commentCount = "0"
                            newPost.category = "Visibility"
                            newPost.location = airportId
                            newPost.postUpdated = Date()
                            newPost.comments = NSSet(array: [AabbaCommentList]())
                            
                            if let oldPosts = dataExist?.posts?.allObjects as? [AabbaPostList] {
                                dataExist?.postCount = "\((dataExist?.postCount as! Int) + 1)"
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
                    .background(Color.theme.azure)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.theme.coralRed1, lineWidth: 0))
            }
        }.padding()
        
    }
    
    func validate() -> Bool {
        if selectedStation != nil {
            return true
        }
        return false
    }
}
