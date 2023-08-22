//
//  ScratchPadForm.swift
//  ATLAS
//
//  Created by phuong phan on 27/06/2023.
//
    
import Foundation
import SwiftUI

struct ScratchPadForm: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController

    @Binding var itemList: [ScratchPadList]
    @Binding var currentIndex: Int // for edit
    @Binding var showSheet: Bool

    @State private var title: String = ""
    @State private var content: String = ""
    
    var resetData: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geo in
            // List categories
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Button(action: {
                            title = ""
                            content = ""
                            self.showSheet.toggle()
                        }) {
                            Text("Cancel").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                        }
                        
                        Spacer()
                        
                        if currentIndex > -1 {
                            Text("Edit Item").foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                        } else {
                            Text("Add New Item").foregroundColor(.black).font(.system(size: 17, weight: .semibold))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if currentIndex > -1 {
                                update()
                            } else {
                                save()
                            }
                        }) {
                            Text("Done").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                        }
                    }
                    .padding()
                    .background(.white)
                    
                    Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("TITLE").foregroundColor(Color.theme.arsenic.opacity(0.6)).font(.system(size: 13, weight: .regular)).padding(.vertical, 16)
                            Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
                            
                            TextField("Tap in this space to type or edit", text: $title, axis: .vertical)
                                .padding(.vertical, 10)
                                .frame(width: geo.size.width - 64 > 0 ? geo.size.width - 64 : geo.size.width, alignment: .leading)
                                .lineLimit(1, reservesSpace: true)
                                .padding(.bottom)
                            
                            Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
                            
                            Text("CONTENT").foregroundColor(Color.theme.arsenic.opacity(0.6)).font(.system(size: 13, weight: .regular)).padding(.vertical, 16)
                            Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
                            
                            TextField("Tap in this space to type or edit", text: $content, axis: .vertical)
                                .padding(.vertical, 10)
                                .frame(width: geo.size.width - 64 > 0 ? geo.size.width - 64 : geo.size.width, alignment: .leading)
                                .lineLimit(8, reservesSpace: true)
                            
                            Spacer()
                        }.padding(.horizontal)
                        
                    }.background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.white)
                    )
                    .padding()
                    
                }.background(Color.theme.platinum)
                    .keyboardAdaptive()
            }.cornerRadius(8)
                .background(.white)
                .frame(maxHeight: .infinity)
                .onAppear {
                    if currentIndex > -1 {
                        self.title = itemList[currentIndex].unwrappedTitle
                        self.content = itemList[currentIndex].content
                    }
                }.onDisappear {
                    title = ""
                    content = ""
                }
        }
    }
    
    func save() {
        let title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !content.isEmpty {
            let item = ScratchPadList(context: persistenceController.container.viewContext)
            item.id = UUID()
            item.orderNum = (itemList.first?.orderNum ?? 0) + 1
            
//            if title.isEmpty {
//                if let firstParagraph = content.components(separatedBy: CharacterSet.newlines).first {
//                    title = firstParagraph
//                }
//            }
            
            item.title = title
            item.content = content
            
            viewModel.save()
            self.viewModel.scratchPadArray = viewModel.readScratchPad()
            
            self.resetData()
            self.showSheet.toggle()
        }
    }
    
    func update() {
        let title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !content.isEmpty {
            
//            if title.isEmpty {
//                if let firstParagraph = content.components(separatedBy: CharacterSet.newlines).first {
//                    title = firstParagraph
//                }
//            }
            
            itemList[currentIndex].title = title
            itemList[currentIndex].content = content
            
            viewModel.save()
            self.viewModel.scratchPadArray = viewModel.readScratchPad()
            
            self.resetData()
            self.showSheet.toggle()
        }
    }
}

//struct ScratchPadForm_Previews: PreviewProvider {
//    static var previews: some View {
//        ScratchPadForm()
//    }
//}
