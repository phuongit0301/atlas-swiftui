//
//  AISearchCompletedView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct AISearchCompletedView: View {
    @EnvironmentObject var network: Network
    @EnvironmentObject var viewModel: CoreDataModelState
    @EnvironmentObject var persistenceController: PersistenceController
    
    @State private var like = Status.normal
    @State private var flag: Bool = false
    @State private var showLoading: Bool = false
    @State var pasteboard = UIPasteboard.general
    // For Search
    @State private var txtSearch: String = ""
    
    @State private var message = ""
    @State private var itemCurrent: AISearchList?
    
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
                            TextField("Enter your search query here", text: $txtSearch)
                                .disabled(true)
                                .submitLabel(.search)
                                .font(.system(size: 17))
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
                                Text("Response is generated here").font(.system(size: 17)).foregroundColor(message != "" ? Color.black : Color.theme.gray).frame(maxWidth: .infinity, alignment: .leading)
                            }.padding(.vertical)
                                .padding(.horizontal, 24)
                        }
                        Spacer()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.theme.sonicSilver.opacity(0.12))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 1)
                    )
                    .padding(.bottom, 16)
                    
                    HStack {
                        Spacer()
                        
                        HStack {
                            Button(action: {
                            }) {
                                Text("Regenerate")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color.theme.azure)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.theme.azure, lineWidth: 0)
                                    )
                                
                                if showLoading {
                                    ActivityIndicator(shouldAnimate: self.$showLoading)
                                }
                            }.disabled(self.showLoading)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white)
                                .cornerRadius(12)
                                .border(Color.theme.azure, width: 1, cornerRadius: 12)
                            
                            Button(action: {
                            }) {
                                Text("Copy")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.init(
                                                Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1), lineWidth: 0)
                                    )
                            }.disabled(self.showLoading)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.theme.azure)
                                .cornerRadius(12)
                                .border(Color.theme.azure, width: 1, cornerRadius: 12)
                            
                            Button(action: {
                            }) {
                                Text("Save to Reference")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color.theme.azure)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.theme.azure, lineWidth: 0)
                                    )
                            }.disabled(self.showLoading)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white)
                                .cornerRadius(12)
                                .border(Color.theme.azure, width: 1, cornerRadius: 12)
                        }//group button
                    }
                    
                    Spacer()
                }
            }.padding(16)
                .background(Color.white)
        }
        
    }
}
