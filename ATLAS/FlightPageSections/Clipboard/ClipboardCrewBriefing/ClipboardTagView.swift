//
//  ClipboardTagView.swift
//  ATLAS
//
//  Created by phuong phan on 13/07/2023.
//

import SwiftUI
import Foundation

struct ClipboardTagView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    
    var notes: [NoteList]
    let tag: TagList
    @State var noteList: [NoteList] = []
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
                            Text(tag.name).font(.system(size: 17, weight: .semibold)).foregroundStyle(Color.black)
                            
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
                
                if isLoading {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black)).padding(.leading)
                } else {
                    VStack(spacing: 0) {
                        if isShowing {
                            if noteList.count <= 0 {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("No note saved").foregroundColor(Color.theme.philippineGray2).font(.system(size: 15, weight: .regular))
                                }.frame(height: 44)
                                Spacer()
                            } else {
                                ForEach(noteList.indices, id: \.self) { index in
                                    if noteList[index].isDefault {
                                        VStack(spacing: 0) {
                                            HStack(alignment: .center) {
                                                Image(systemName: "line.3.horizontal")
                                                    .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                                    .frame(width: 22, height: 22)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                                
                                                VStack(alignment: .leading, spacing: 8) {
                                                    Text(noteList[index].unwrappedName).font(.system(size: 15, weight: .regular)).foregroundColor(.black)
                                                    
                                                    HStack(spacing: 8) {
                                                        Text(tag.name).padding(.vertical, 4)
                                                            .padding(.horizontal, 12)
                                                            .font(.system(size: 11, weight: .regular))
                                                            .background(Color.white)
                                                            .foregroundColor(Color.black)
                                                            .cornerRadius(12)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .stroke(Color.black, lineWidth: 1)
                                                            )
                                                        
                                                        Text(renderDate(notes[index].unwrappedCreatedAt)).font(.system(size: 11, weight: .regular)).foregroundColor(Color.theme.arsenic.opacity(0.6))
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    noteList[index].isDefault.toggle()
                                                    coreDataModel.save()
                                                    coreDataModel.tagList = coreDataModel.readTag()
                                                }, label: {
                                                    if noteList[index].isDefault {
                                                        Image(systemName: "star.fill")
                                                            .foregroundColor(Color.theme.azure)
                                                            .font(.system(size: 22))
                                                    } else {
                                                        Image(systemName: "star")
                                                            .foregroundColor(Color.theme.azure)
                                                            .font(.system(size: 22))
                                                    }
                                                }).buttonStyle(PlainButtonStyle())
                                                
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(Color.theme.charlestonGreen)
                                                    .scaledToFit()
                                                    .aspectRatio(contentMode: .fit)
                                            }.padding(.vertical, 8)
                                            if index + 1 < noteList.count {
                                                Divider().padding(.horizontal, -16)
                                            }
                                        }.id(UUID())
                                    }
                                }.onMove(perform: move)
                            }
                        }
                    }.padding(.bottom)
                }
            }.padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 0))
                .onAppear {
                    self.isLoading = true
                    for item in notes {
                        if item.isDefault {
                            self.noteList.append(item)
                        }
                    }
                    self.isLoading = false
                }
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        self.noteList.move(fromOffsets: source, toOffset: destination)
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
