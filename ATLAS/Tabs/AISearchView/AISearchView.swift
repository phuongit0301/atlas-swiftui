//
//  AISearchView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct AISearchView: View {
    @EnvironmentObject var network: Network
    
    @State private var like = Status.normal
    @State private var flag: Bool = false
    @State private var showLoading: Bool = false
    @State private var firstLoading: Bool = true
    // For Search
    @State private var txtSearch: String = ""
    
    @State private var message = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                // flight informations
                HStack {
                    Text("Search")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: {
                        txtSearch = ""
                        message = ""
                    }) {
                        Text("New Search").font(.system(size: 17)).foregroundColor(Color.theme.azure)
                    }
                }
                
                VStack {
                    HStack {
                        HStack {
                            if showLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            }
                            TextField("Search", text: $txtSearch)
                                .onSubmit {
                                    message = ""
                                    onSearch()
                                }
                                .font(.custom("Inter-Regular", size: 16))
                                .padding(13)
                                .frame(maxWidth: .infinity, maxHeight: 48)
                        }.padding(.horizontal, 12)
                            .padding(.vertical, 6)
                    }
                    .background(Color.theme.sonicSilver.opacity(0.12))
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 1)
                    )
                    
                    VStack(alignment: .leading) {
                        if txtSearch != "" && message != "" {
                            VStack(spacing: 0) {
                                // search form
                                TypingText(text: message)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        } else {
                            VStack(alignment: .leading) {
                                Text("Response is generated here").font(.system(size: 17, weight: .regular)).foregroundColor(Color.black).frame(maxWidth: .infinity, alignment: .leading)
                            }.padding()
                        }
                        Spacer()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.theme.sonicSilver.opacity(0.12))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 1)
                    )
                    
                }
            }.padding(16)
                .background(Color.white)
                .cornerRadius(8)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }.padding(16)
        
    }
    
    func onSearch() {
        self.showLoading = true
        network.handleSearch(question: txtSearch, onSuccess: {
            self.showLoading = false
            
            withAnimation {
                message = network.dataSearch.result
            }
        }, onFailure: { error in
            self.showLoading = false
            print("Error fetch data == \(error)")
        })
    }
}

struct AISearchView_Preview: PreviewProvider {
    static var previews: some View {
        AISearchView()
    }
}
