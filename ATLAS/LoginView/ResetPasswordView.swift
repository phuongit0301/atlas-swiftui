//
//  ResetPasswordView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI

struct ResetPasswordView: View {
    @Binding var isShowResetPassword: Bool
    @State var email = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowResetPassword.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                
                Spacer()
                
                Text("Reset Password").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Email").font(.system(size: 15, weight: .semibold))
                    }.frame(height: 44)
                    
                    HStack {
                        TextField("Enter your airline email address", text: $email).font(.system(size: 15, weight: .regular))
                    }.frame(height: 44)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                                .foregroundColor(.white)
                        )
                }
                
                Button {
                    //Todo
                } label: {
                    Text("Reset Password")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .semibold))
                        .frame(height: 20)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.theme.philippineGray3)
                        )
                    
                }
            }.padding()
     
            Spacer()
        }.background(Color.theme.antiFlashWhite)
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(isShowResetPassword: .constant(true))
    }
}
