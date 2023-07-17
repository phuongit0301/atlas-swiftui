//
//  ScratchPadEditSplitForm.swift
//  ATLAS
//
//  Created by phuong phan on 27/06/2023.
//
    
import Foundation
import SwiftUI

struct ScratchPadEditSplitForm: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController

    @Binding var itemList: [ScratchPadList]
    @Binding var currentIndex: Int // for edit
    @Binding var showSheetEdit: Bool

    @State private var title: String = ""
    @State private var content: String = ""
    
    var resetData: () -> Void
    @Binding var pasteboard: UIPasteboard
    
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geo in
            // List categories
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        TextField("Tap in this space to type or edit", text: $title, axis: .vertical)
                            .padding(.vertical, 10)
                            .lineLimit(1, reservesSpace: true)
                        
                        Spacer()
                        
                        Button(action: {
                            pasteboard.string = itemList[currentIndex].content
                        }) {
                            Text("Copy").foregroundColor(Color.white)
                                .font(.system(size: 17, weight: .regular))
                                .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                        }.background(Color.theme.azure)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white, lineWidth: 1)
                        )
                        
                        Button(action: {
                            update()
                        }) {
                            Text("Done").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                        }
                    }
                    .padding()
                    
                    Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        TextField("Tap in this space to type or edit", text: $content, axis: .vertical)
                            .padding()
                            .lineLimit(8, reservesSpace: true)
                        
                        Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
                        Spacer()
                    }
                }.frame(height: geo.size.height)
            }.frame(maxHeight: .infinity)
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
        var title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !content.isEmpty {
            let item = ScratchPadList(context: persistenceController.container.viewContext)
            item.id = UUID()
            
            if title.isEmpty {
                if let firstParagraph = content.components(separatedBy: CharacterSet.newlines).first {
                    title = firstParagraph
                }
            }
            
            item.title = title
            item.content = content
            
            viewModel.save()
            self.viewModel.scratchPadArray = viewModel.readScratchPad()
            
            self.resetData()
            self.showSheetEdit.toggle()
        }
    }
    
    func update() {
        var title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !content.isEmpty {
            
            if title.isEmpty {
                if let firstParagraph = content.components(separatedBy: CharacterSet.newlines).first {
                    title = firstParagraph
                }
            }
            
            itemList[currentIndex].title = title
            itemList[currentIndex].content = content
            
            viewModel.save()
            self.viewModel.scratchPadArray = viewModel.readScratchPad()
            
            self.resetData()
            self.showSheetEdit.toggle()
        }
    }
}

//struct ScratchPadForm_Previews: PreviewProvider {
//    static var previews: some View {
//        ScratchPadForm()
//    }
//}
