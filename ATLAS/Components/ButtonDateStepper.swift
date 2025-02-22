//
//  ButtonDateStepper.swift
//  ATLAS
//
//  Created by phuong phan on 28/06/2023.
//

import SwiftUI

struct ButtonDateStepper: View {
    @State var onToggle: () -> Void
    @Binding var value: Date
    @State var suffix: String? = ""
    
    var body: some View {
        Button(action: { onToggle() }, label: {
            HStack {
                Text("\(parseDateString(value))\(suffix ?? "")").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    .padding(.trailing, 16)
                
                Spacer()
                
                VStack {
                    Image(systemName: "chevron.up.chevron.down").foregroundColor(Color.theme.azure)
                }
            }.contentShape(Rectangle())
        }).buttonStyle(.plain)
    }
    
    func parseDateString(_ value: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let timeString = dateFormatter.string(from: value)
        return timeString
    }
}

struct ButtonDateStepper1: View {
    @State var onToggle: () -> Void
    @Binding var value: Date
    @State var suffix: String? = ""
    
    var body: some View {
        Button(action: { onToggle() }, label: {
            HStack {
                Text("\(parseDateString(value))\(suffix ?? "")").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    .padding(.trailing, 16)
                
                Spacer()
                
                VStack {
                    Image(systemName: "chevron.up.chevron.down").foregroundColor(Color.theme.azure)
                }
            }.contentShape(Rectangle())
        }).buttonStyle(.plain)
    }
    
    func parseDateString(_ value: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let timeString = dateFormatter.string(from: value)
        return timeString
    }
}
//struct ButtonStepper_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonStepper(onToggle: func onToggle() {} , value: .constant(10))
//    }
//}
