//
//  LoginView.swift
//  ATLAS
//
//  Created by phuong phan on 26/07/2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var message = ""
    @AppStorage("uid") var userID: String = ""
    
    @State private var isShowResetPassword = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Image("logo")
                        .frame(width: 100, height: 32)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 48)
                }
                
                VStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 16) {
                            Text("Email").font(.system(size: 15, weight: .semibold))
                            
                            Text("Please enter a valid airline email address").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                        }.frame(height: 44)
                        
                        HStack {
                            TextField("Enter your airline email address", text: $email).font(.system(size: 15, weight: .regular))
                            //                    if(email.count != 0) {
                            //                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            //                            .fontWeight(.bold)
                            //                            .foregroundColor(email.isValidEmail() ? .green : .red)
                            //                    }
                            
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
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 16) {
                            Text("Password").font(.system(size: 15, weight: .semibold))
                            
                            Spacer()
                            
                            Button(action: {
                                self.isShowResetPassword.toggle()
                            }, label: {
                                Text("Forgot Password").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.azure)
                            })
                        }.frame(height: 44)
                        
                        HStack {
                            SecureField("Password", text: $password)
                            
                            Spacer()
                            
                            Image(systemName: "eye.slash")
                            
                            //                        if(password.count != 0) {
                            //
                            //                            Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                            //                                .fontWeight(.bold)
                            //                                .foregroundColor(isValidPassword(password) ? .green : .red)
                            //                        }
                            
                        }.frame(height: 44)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 0)
                                    .foregroundColor(.white)
                            )
                    }.padding(.bottom, 8)
                    
                    Button {
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                message = error.localizedDescription
                                print(error)
                                return
                            }
                            
                            if let authResult = authResult {
                                print(authResult.user.uid)
                                withAnimation {
                                    userID = authResult.user.uid
                                }
                            }
                        }
                    } label: {
                        Text("Sign In")
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
                    
                    VStack(spacing: 0) {
                        Text("The email address you provided is not registered.").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                        Text("Create a new account?").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.azure).underline()
                    }
                }.padding(24)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 0)
                            .foregroundColor(.white)
                    )
                    .padding(.bottom, 24)
                
                
//                if message != "" {
//                    Text(message).font(.system(size: 17)).foregroundColor(.red).frame(alignment: .leading)
//                }
                
                VStack(spacing: 0) {
                    HStack(alignment: .center, spacing: 0) {
                        Text("By clicking \"Sign In\", you agree to our").font(.system(size: 13, weight: .regular)).foregroundColor(Color.black)
                        Text(" Terms of Service").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.azure)
                        Text(" and").font(.system(size: 13, weight: .regular)).foregroundColor(Color.black)
                        Text(" Privacy Policy").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                    HStack {
                        Text("Don’t have an account?").font(.system(size: 13, weight: .regular)).foregroundColor(Color.black)
                        Text(" Sign up").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.azure)
                    }
                }
                
                Spacer()
                
                Text("Copyright 2003 Accumulus Pte. Ltd. All Rights Reserved ").font(.system(size: 13, weight: .regular)).foregroundColor(Color.black).padding(.bottom, 50)
                
            }.frame(width: 488)
                
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 48)
            .background(Color.theme.antiFlashWhite)
            .formSheet(isPresented: $isShowResetPassword) {
                ResetPasswordView(isShowResetPassword: $isShowResetPassword)
            }
    }
    
    private func isValidPassword(_ password: String) -> Bool {
            // minimum 6 characters long
            // 1 uppercase character
            // 1 special char
            
            let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
            
            return passwordRegex.evaluate(with: password)
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

