//
//  SignUpView.swift
//  ATLAS
//
//  Created by phuong phan on 05/10/2023.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @Binding var step: Int
    @Binding var isShowing: Bool
    @Binding var userInfo: [String: String]
    
    @State var email = ""
    @State var errorMsg = ""
    @State private var isLoading = false
    
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
                    HStack {
                        Text("Email").font(.system(size: 15, weight: .semibold))
                        
                        if email.count != 0 && !email.isValidEmail() {
                            Text("Please enter a valid airline email address").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                        }
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
                
                HStack(alignment: .center, spacing: 16) {
                    HStack(alignment: .center, spacing: 0) {
                        Text("By clicking \"Continue\", you agree to our").font(.system(size: 13, weight: .regular)).foregroundColor(Color.black)
                        Text(" Terms of Service").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.azure)
                        Text(" and").font(.system(size: 13, weight: .regular)).foregroundColor(Color.black)
                        Text(" Privacy Policy").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                    
                    Button {
                        isLoading = true
                        let password = randomAlphanumericString(10)
                        print("password======\(password)")
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let err = error {
                                isLoading = false
                                errorMsg = err.localizedDescription
                                return
                            }

                            if ((authResult?.user) != nil) {
                                Auth.auth().currentUser?.sendEmailVerification { (err) in
                                    if let err = err {
                                        errorMsg = err.localizedDescription
                                        return
                                    }
                                    userInfo["email"] = email
                                    userInfo["password"] = password
                                    
                                    isLoading = false
                                    step += 1
                                    isShowing.toggle()
                                }
                            }

                        }
                    } label: {
                        HStack(alignment: .center, spacing: 16) {
                            if isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            }
                            
                            Text("Continue")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .semibold))
                        }
                        
                    }.frame(width: 200, height: 20)
                        .padding(.vertical, 12)
                        .cornerRadius(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(email.isValidEmail() ? Color.theme.azure : Color.theme.philippineGray3)
                        )
                }
                
                if errorMsg.count != 0 {
                    Text(errorMsg).font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                }
            }.padding()
     
            Spacer()
        }.background(Color.theme.antiFlashWhite)
    }
}
