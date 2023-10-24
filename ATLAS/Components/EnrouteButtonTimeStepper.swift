//
//  EnrouteButtonTimeStepper.swift
//  ATLAS
//
//  Created by phuong phan on 28/06/2023.
//

import SwiftUI

struct EnrouteButtonTimeStepper: View {
    @State var onToggle: (_ index: Int) -> Void
    @State var value: String = "0000"
    @Binding var index: Int
    
    var body: some View {
        Button(action: { onToggle(index) }, label: {
            HStack {
                Text("\(value)").font(.system(size: 20, weight: .regular)).foregroundColor(Color.theme.azure)
                    .padding(.trailing, 8)
                
                Spacer()
                
                VStack {
                    Image(systemName: "chevron.up").foregroundColor(Color.theme.azure)
                    Image(systemName: "chevron.down").foregroundColor(Color.theme.azure)
                }
            }.contentShape(Rectangle())
        }).buttonStyle(.plain)
    }
}

// For Map
struct FlightLevelButtonTimeStepper: View {
    @State var onToggle: (_ index: Int) -> Void
    @State var value: String = "0000"
    @Binding var index: Int
    
    var body: some View {
        Button(action: { onToggle(index) }, label: {
            HStack(spacing: 4) {
                Text("\(value)").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.azure)
                
                VStack(spacing: 0) {
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundColor(Color.theme.azure)
                        .font(.system(size: 12, weight: .medium))
                }
            }
        }).buttonStyle(.plain)
    }
}

// For Map
struct FlightTimeButtonTimeStepper: View {
    @State var onToggle: () -> Void
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text("\(value)").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
            
            VStack(spacing: 0) {
                Image(systemName: "chevron.up.chevron.down")
                    .foregroundColor(Color.theme.azure)
                    .font(.system(size: 15, weight: .medium))
            }
        }.contentShape(Rectangle())
            .onTapGesture {
                onToggle()
            }
    }
}
