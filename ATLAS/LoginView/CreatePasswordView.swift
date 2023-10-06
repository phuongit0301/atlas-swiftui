//
//  CreatePasswordView.swift
//  ATLAS
//
//  Created by phuong phan on 05/10/2023.
//

import SwiftUI
import Firebase

struct CreatePasswordView: View {
    @Binding var step: Int
    @Binding var isShowing: Bool
    
    @AppStorage("uid") var userID: String = ""
    @AppStorage("isOnboarding") var isOnboarding: String = "0"
    
    @State var isSecured: Bool = true
    @State var isLoading: Bool = false
    @State var password = ""
    @State var confirmPassword = ""
    @State var errorMsg = ""
    
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
                        Text("Password").font(.system(size: 15, weight: .semibold))
                        
                        if password.count != 0 && !isValidPassword(password) {
                            Text("Password is missing a lower case letter, an upper case letter, or a number").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                        }
                    }.frame(height: 44)
                    
                    HStack {
                        HStack {
                            if isSecured {
                                SecureField("Enter your password", text: $password)
                            } else {
                                TextField("Enter your password", text: $password)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                self.isSecured.toggle()
                            }, label: {
                                Image(systemName: "eye.slash")
                            })
                            
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
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Text("Confirm Password").font(.system(size: 15, weight: .semibold))
                        
                        if confirmPassword.count != 0 {
                            if password.count != 0 && isValidPassword(confirmPassword) && password != confirmPassword {
                                Text("Passwords do not match").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                            }
                            if !isValidPassword(confirmPassword) {
                                Text("Password is missing a lower case letter, an upper case letter, or a number").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                            }
                        }
                        
                    }.frame(height: 44)
                    
                    HStack {
                        SecureField("Enter your chosen password", text: $confirmPassword)
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
                    if checkValid(), let user = Auth.auth().currentUser {
                        user.updatePassword(to: password) { error in
                            if let err = error {
                                isLoading = false
                                errorMsg = err.localizedDescription
                                return
                            }

                            self.userID = user.uid
                            self.isOnboarding = "1"
                            self.isShowing.toggle()
                        }
                    }
                } label: {
                    HStack(alignment: .center, spacing: 16) {
                        if isLoading {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                        
                        Text("Complete Sign Up")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .semibold))
                            .frame(height: 20)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(checkValid() ? Color.theme.azure : Color.theme.philippineGray3)
                            )
                    }
                    
                }
                
                if errorMsg.count != 0 {
                    Text(errorMsg).font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                }
            }.padding()
     
            Spacer()
        }.background(Color.theme.antiFlashWhite)
    }
    
    func checkValid() -> Bool {
        return password.count > 0 && isValidPassword(password) && confirmPassword.count > 0 && isValidPassword(confirmPassword) && password == confirmPassword
    }
}
