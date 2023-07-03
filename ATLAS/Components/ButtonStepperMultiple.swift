//
//  CustomStepper.swift
//  ATLAS
//
//  Created by phuong phan on 28/06/2023.
//

import SwiftUI

struct ButtonStepperMultiple: View {
    @State var onToggle: () -> Void
    @Binding var value: String
    @State var suffix: String? = ""
    
    var body: some View {
        Button(action: { onToggle() }, label: {
            HStack {
                Text("\(value)\(suffix ?? "")").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                    .padding(.trailing, 16)
                
                Spacer()
                
                VStack {
                    Image(systemName: "chevron.up").foregroundColor(Color.theme.azure)
                    Image(systemName: "chevron.down").foregroundColor(Color.theme.azure)
                }
            }
        }).buttonStyle(.plain)
    }
}

//struct ButtonStepper_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonStepper(onToggle: func onToggle() {} , value: .constant(10))
//    }
//}
