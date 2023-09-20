//
//  TurbulencePopoverView.swift
//  ATLAS
//
//  Created by phuong phan on 17/09/2023.
//

import SwiftUI

struct TurbulencePopoverView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var mapIconModel: MapIconModel
    
    @Binding var isShowing: Bool
    @State var selectedWaypoint: String = ""
    
    @State var selectedModerate: ModerateDataDropDown = .fight
    @State var flightLevel: String = "0000"
    @State private var selectionOutputFlight = "Select Flight Level"
    @State var isShowFlightModal = false
    
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
                
                Text("Turbulence").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.black)
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("Done").font(Font.custom("SF Pro", size: 15).weight(.semibold)).foregroundColor(Color.theme.azure)
                }.opacity(0)
            }.background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            Picker("Select Waypoint", selection: $selectedWaypoint) {
                Text("Select Waypoint").tag("")
                ForEach(mapIconModel.dataWaypoint, id: \.self) {
                    Text($0).tag($0)
                }
            }.pickerStyle(MenuPickerStyle())
                .padding(.leading, -12)
            
            HStack {
                EnrouteButtonTimeStepper(onToggle: onFlight, value: selectionOutputFlight, index: .constant(0)).fixedSize().id(UUID())
            }
            
            HStack {
                Text("Severity").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                
                Spacer()
                
                Picker("", selection: $selectedModerate) {
                    ForEach(ModerateDataDropDown.allCases, id: \.self) {
                        Text($0.rawValue.capitalized).tag($0).font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                    }
                }.pickerStyle(MenuPickerStyle())
                
                Button(action: {
                    if validate() {
                        let dataExist = coreDataModel.findOneAabba(name: selectedWaypoint)
                        
                        if dataExist != nil {
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let newPost = AabbaPostList(context: persistenceController.container.viewContext)
                            newPost.id = UUID()
                            newPost.postId = ""
                            newPost.userId = "abc122" // Todo: Change to user login
                            newPost.postDate = dateFormatter.string(from: Date())
                            newPost.postTitle = "Ride Report"
                            newPost.postText = "\(selectionOutputFlight) \(selectedModerate.rawValue.capitalized)"
                            newPost.upvoteCount = "0"
                            newPost.commentCount = "0"
                            newPost.category = "Turbulence"
                            newPost.location = selectedWaypoint
                            newPost.postUpdated = Date()
                            newPost.comments = NSSet(array: [AabbaCommentList]())
                            
                            if let oldPosts = dataExist?.posts?.allObjects as? [AabbaPostList] {
                                dataExist?.postCount += 1
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
            }
            
        }.padding()
            .formSheet(isPresented: $isShowFlightModal) {
                EnrouteModalWheelAfl(isShowing: $isShowFlightModal, selectionInOut: $selectionOutputFlight, defaultValue: .constant("00"))
            }
    }
    
    func validate() -> Bool {
        if selectedWaypoint != "" && selectionOutputFlight != "Select Flight Level" {
            return true
        }
        return false
    }
    
    func onFlight(_ index: Int) {
        self.isShowFlightModal.toggle()
    }
}
