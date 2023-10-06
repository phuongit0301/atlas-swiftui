//
//  ResetPasswordView.swift
//  ATLAS
//
//  Created by phuong phan on 01/10/2023.
//

import SwiftUI
import Firebase

struct ResetPasswordView: View {
    @Binding var isShowResetPassword: Bool
    
    @State private var email = ""
    @State private var errorMsg = ""
    @State private var isSent = false
    @State private var isLoading = false
    
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
                        TextField("Enter your airline email address", text: $email).font(.system(size: 15, weight: .regular)).textInputAutocapitalization(.never)
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
                
                Spacer()
                
                Button {
                    if email.count > 0 && email.isValidEmail() {
                        isLoading = true
                        Auth.auth().sendPasswordReset(withEmail: email) { error in
                            isLoading = false
                            errorMsg = ""
                            
                            if let err = error {
                                errorMsg = err.localizedDescription
                                return
                            }
                            self.isSent = true
                        }
                    }
                } label: {
                    HStack(alignment: .center, spacing: 16) {
                        if isLoading {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                        Text("Reset Password")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .semibold))
                    }
                    
                }.buttonStyle(PlainButtonStyle())
                    .frame(height: 20)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(!isSent && email.count > 0 && email.isValidEmail() ? Color.theme.azure : Color.theme.philippineGray3)
                    )
                    .cornerRadius(8)
                
                if errorMsg.count != 0 {
                    Text(errorMsg).font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                }
                
                if isSent {
                    Text("A password reset email has been sent to your email address.").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.theme.ufoGreen).padding(.bottom, 16)
                    Text("Please click the link in that email to reset your password.").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.ufoGreen).padding(.bottom, 10)
                    Text("If you do not receive the email, please check your spam folder or other filtering tools.").font(.system(size: 15, weight: .regular)).foregroundColor(Color.theme.ufoGreen)
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
