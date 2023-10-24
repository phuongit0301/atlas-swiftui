//
//  ClipboardTagCompletedView.swift
//  ATLAS
//
//  Created by phuong phan on 13/07/2023.
//

import SwiftUI
import Foundation

struct ClipboardTagCompletedView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var mapIconModel: MapIconModel
    
    @Binding var itemList: [CabinDefectModel]
    let tag: String

    @State var isShowing = true
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: {
                        self.isShowing.toggle()
                    }, label: {
                        HStack(alignment: .center, spacing: 8) {
                            Text(tag).font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                            
                            if isShowing {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(Color.blue)
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }.frame(alignment: .leading)
                    }).buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }.frame(height: 54)
                
                VStack(spacing: 0) {
                    if isShowing {
                        if itemList.count <= 0 {
                            HStack(spacing: 0) {
                                Text("No note saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 15, weight: .regular))
                                Spacer()
                            }.frame(height: 44, alignment: .leading)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(itemList.indices, id: \.self) { index in
                                    VStack(spacing: 0) {
                                        HStack(alignment: .center) {
                                            Image(systemName: "line.3.horizontal")
                                                .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                                .frame(width: 22, height: 22)
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                            
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(itemList[index].postName).font(.system(size: 15, weight: .regular)).foregroundColor(.black)
                                                
                                                HStack(spacing: 8) {
                                                    Text(itemList[index].tagName).padding(.vertical, 4)
                                                        .padding(.horizontal, 12)
                                                        .font(.system(size: 11, weight: .regular))
                                                        .background(Color.theme.azure)
                                                        .foregroundColor(Color.white)
                                                        .cornerRadius(12)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(Color.theme.azure, lineWidth: 0)
                                                        )
                                                    
                                                    Text(renderDate(itemList[index].postDate)).font(.system(size: 11, weight: .regular)).foregroundColor(Color.theme.arsenic.opacity(0.6))
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                            }, label: {
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(Color.theme.azure)
                                                    .font(.system(size: 22))
                                            }).buttonStyle(PlainButtonStyle())
                                        }.padding(.vertical, 8)
                                        
                                        if index + 1 < itemList.count {
                                            Divider().padding(.horizontal, -16)
                                        }
                                    }.id(UUID())
                                }
                            }.padding(.bottom, 8)
                        }
                    }
                }
            }.padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
        }
    }
   
    func renderDate(_ date: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateFormat = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd/MM/yy HHmm"
            return dateFormatter.string(from: dateFormat)
        }

        return ""
    }
}
