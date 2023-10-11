//
//  LoginView.swift
//  ATLAS
//
//  Created by phuong phan on 26/07/2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var onboardingModel: OnboardingModel
    @EnvironmentObject var signupModel: SignUpModel
    @AppStorage("isLogin") var isLogin: String = "0"
    
    @State var step = 1
    @State var email = ""
    @State var password = ""
    @State var message = ""
    @State var isSecured: Bool = true
    @State var showEmailNotVerified: Bool = false
    @AppStorage("uid") var userID: String = ""
    @State var userInfo: [String: String] = [:]
    
    @State private var isShowResetPassword = false
    @State private var isShowSignup = false
    @State private var isShowVerifyEmail = false
    @State private var isShowCreatePassword = false
    
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
                            
                            if email.count > 0 && !email.isValidEmail() {
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
                            if isSecured {
                                SecureField("Password", text: $password)
                            } else {
                                TextField("Password", text: $password)
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
                                    .stroke(lineWidth: 0)
                                    .foregroundColor(.white)
                            )
                    }.padding(.bottom, 8)
                    
                    Button {
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                message = error.localizedDescription
                                return
                            }
                            
                            if let authResult = authResult, authResult.user.isEmailVerified {
                                print(authResult.user.uid)
                                coreDataModel.isLoginLoading = true
                                withAnimation {
                                    userID = authResult.user.uid
                                    isLogin = "1"
                                }
                            } else {
                                showEmailNotVerified = true
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
                                    .fill(validate())
                            )
                            
                    }
                    
                    VStack(spacing: 0) {
                        if message.count > 0 {
                            Text(message).font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                        }
                        
                        if showEmailNotVerified {
                            VStack {
                                Text("Your email address has not been verified.")
                                    .font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.coralRed1)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Text("Please click the link in the verification email sent to your email address to proceed.")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(Color.theme.coralRed1).padding(.bottom, 10)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Text("If you do not receive the email, please check your spam folder or other filtering tools.")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(Color.theme.coralRed1)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }.frame(alignment: .center)
                            .frame(maxWidth: .infinity)
                        }
                        
                        Button(action: {
                            self.isShowSignup.toggle()
                        }, label: {
                            Text("Create a new account?").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.azure).underline()
                        }).buttonStyle(PlainButtonStyle())
                        
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
                        Button(action: {
                            self.isShowSignup.toggle()
                        }, label: {
                            Text(" Sign up").font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.azure)
                        })
                    }
                }
                
                Spacer()
                
                Text("Copyright 2003 Accumulus Pte. Ltd. All Rights Reserved ").font(.system(size: 13, weight: .regular)).foregroundColor(Color.black).padding(.bottom, 50)
                
            }.frame(width: 550)
                
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 48)
            .background(Color.theme.antiFlashWhite)
            .formSheet(isPresented: $isShowResetPassword) {
                ResetPasswordView(isShowResetPassword: $isShowResetPassword).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $isShowSignup) {
                SignUpView(step: $step, isShowing: $isShowSignup, userInfo: $userInfo).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $isShowVerifyEmail) {
                VerifyEmailView(step: $step, isShowing: $isShowVerifyEmail, userInfo: $userInfo).interactiveDismissDisabled(true)
            }
            .formSheet(isPresented: $isShowCreatePassword) {
                CreatePasswordView(step: $step, isShowing: $isShowCreatePassword).interactiveDismissDisabled(true)
            }
            .onChange(of: isShowSignup) {newValue in
                if !newValue && step == 2 {
                    isShowVerifyEmail.toggle()
                }
            }
            .onChange(of: isShowVerifyEmail) {newValue in
                if !newValue && step == 3 {
                    isShowCreatePassword.toggle()
                }
            }
    }
    
    func validate() -> Color {
        if email.count > 0 && email.isValidEmail() && password.count > 0 {
            return Color.theme.azure
        }
        return Color.theme.philippineGray3
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

