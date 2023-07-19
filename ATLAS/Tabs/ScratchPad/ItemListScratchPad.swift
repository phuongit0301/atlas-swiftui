//
//  ItemListScratchPad.swift
//  ATLAS
//
//  Created by phuong phan on 27/06/2023.
//

import SwiftUI

struct ItemListScratchPad: View {
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @State var header: String = "" // "Aircraft Status"
    @Binding var showSheet: Bool
    @Binding var showSheetEdit: Bool
    @Binding var currentIndex: Int
    @Binding var itemList: [ScratchPadList] // itemList
    var geoWidth: Double
    var delete: (_ index: Int) -> Void
    @Binding var pasteboard: UIPasteboard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(header).foregroundColor(Color.theme.eerieBlack).font(.system(size: 20, weight: .semibold))
                Spacer()
                
                Button(action: {
                    if let clipboardText = pasteboard.string {
                        cloneItem(clipboardText)
                    }
                }) {
                    Text("Paste").foregroundColor(Color.white)
                        .font(.system(size: 17, weight: .regular))
                        .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                }.background(Color.theme.azure)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 1)
                )
                .padding(.horizontal)
                
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    Text("Add Note").foregroundColor(Color.theme.azure)
                        .font(.system(size: 17, weight: .regular))
                }
            }.padding(.vertical, 16)
            Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
            
            if itemList.isEmpty {
                VStack(alignment: .leading) {
                    Text("No scratch pad saved. Tap on Add Note to save your first scratch pad.").foregroundColor(Color.theme.philippineGray2).font(.system(size: 17, weight: .regular)).padding()
                    Rectangle().fill(Color.theme.arsenic.opacity(0.36)).frame(height: 1)
                }
                Spacer()
            } else {
                VStack(spacing: 0) {
                    List {
                        ForEach(itemList.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center) {
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundColor(Color.theme.arsenic.opacity(0.3))
                                        .frame(width: 22, height: 22)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(itemList[index].unwrappedTitle.trimmingCharacters(in: .whitespacesAndNewlines))
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .font(.system(size: 16, weight: .regular))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color.theme.charlestonGreen)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: geoWidth, alignment: .leading)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.white)
                            .onTapGesture {
                                self.currentIndex = index
                                self.showSheetEdit.toggle()
                            }
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    delete(index)
                                } label: {
                                    Text("Delete").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                }.tint(Color.theme.coralRed)
                                
                                Button {
//                                    self.currentIndex = index
                                    pasteboard.string = itemList[index].content
//                                    self.showSheetEdit.toggle()
                                } label: {
                                    Text("Copy").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                }
                                .tint(Color.theme.azure)
                                
//                                Button {
//                                    // todo: handle click info button
//                                } label: {
//                                    Text("Info").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
//                                }
//                                .tint(Color.theme.graniteGray)
                            }
                        }.onMove(perform: move)
                    }.listStyle(.plain)
                        .listRowBackground(Color.white)
                        .padding(.bottom, 5)
                }
            }
            
        }
    }
    
    func cloneItem(_ content: String) {
        let item = ScratchPadList(context: persistenceController.container.viewContext)
        item.id = UUID()

        if let firstParagraph = content.components(separatedBy: CharacterSet.newlines).first {
            item.title = firstParagraph
        }

        item.content = content

        viewModel.save()
        self.viewModel.scratchPadArray = viewModel.readScratchPad()
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        print("Move");
        self.itemList.move(fromOffsets: source, toOffset: destination)
    }
}

//struct ItemListScratchPad_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemListScratchPad()
//    }
//}
