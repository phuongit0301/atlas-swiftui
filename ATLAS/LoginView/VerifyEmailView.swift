//
//  VerifyEmailView.swift
//  ATLAS
//
//  Created by phuong phan on 05/10/2023.
//

import SwiftUI
import Firebase

struct VerifyEmailView: View {
    @Binding var step: Int
    @Binding var isShowing: Bool
    @Binding var userInfo: [String: String]
    
    @State var showError = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Button(action: {
                    self.isShowing.toggle()
                }) {
                    Text("Cancel").font(.system(size: 17, weight: .regular)).foregroundColor(Color.theme.azure)
                }
                
                Spacer()
                
                Text("Sign up to Atlas (Step \(step) of 3)").font(.system(size: 17, weight: .semibold)).foregroundColor(Color.black)
                
                Spacer()
                
                Text("Done").font(.system(size: 17, weight: .regular)).opacity(0)
            }.padding()
                .background(.white)
                .roundedCorner(12, corners: [.topLeft, .topRight])
            
            Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Verify Email").font(.system(size: 15, weight: .semibold)).foregroundColor(Color.black).padding(.bottom, 16)
                    Text("A verification email has been sent to your email address. Please click the link in that email to verify your email, and then tap “Continue” below to continue with the sign up process.").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black).padding(.bottom, 10)
                    Text("If you do not receive the email, please check your spam folder or other filtering tools..").font(.system(size: 15, weight: .regular)).foregroundColor(Color.black)
                }
                
                Spacer()
                
                Button {
                    if userInfo.count > 0, let email = userInfo["email"], let password = userInfo["password"] {
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let user = authResult, user.user.isEmailVerified {
                                step += 1
                                self.isShowing.toggle()
                            } else {
                                showError = true
                            }
                        }
                    }
                } label: {
                    Text("Continue")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .semibold))
                        .frame(height: 20)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.theme.azure)
                        )
                    
                }
                
                if showError {
                    VStack {
                        Text("Your email address has not been verified.").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                        Text("Please click the link in the verification email sent to your email address to proceed.").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1).padding(.bottom, 10)
                        Text("If you do not receive the email, please check your spam folder or other filtering tools.").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                    }.frame(maxWidth: .infinity)
                        .frame(alignment: .center)
                }
                

            }.padding()
     
            Spacer()
        }.background(Color.theme.antiFlashWhite)
    }
}
