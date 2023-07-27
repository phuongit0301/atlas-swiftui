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
    
    var body: some View {
        VStack {
                        HStack {
                            Text("Welcome Back!")
                                .font(.largeTitle)
                                .bold()
                            
                            Spacer()
                        }
                        .padding()
                        .padding(.top)
                        
                        Spacer()
            HStack {
                Image(systemName: "mail")
                TextField("Email", text: $email)
                
                Spacer()
                
                
                if(email.count != 0) {
                    
                    Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(email.isValidEmail() ? .green : .red)
                }
                
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.black)
                
            )
            .padding()
            
            HStack {
                Image(systemName: "lock")
                SecureField("Password", text: $password)
                
                Spacer()
                
                if(password.count != 0) {
                    
                    Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(isValidPassword(password) ? .green : .red)
                }
                
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.black)
                
            )
            .padding()
            
            if message != "" {
                Text(message).font(.system(size: 17)).foregroundColor(.red).frame(alignment: .leading)
            }
            Spacer()
            
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
                    .font(.title3)
                    .bold()
                
                    .frame(maxWidth: .infinity)
                    .padding()
                
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                    )
                    .padding(.horizontal)
            }
        }
        .padding()
    }
    
    private func isValidPassword(_ password: String) -> Bool {
            // minimum 6 characters long
            // 1 uppercase character
            // 1 special char
            
            let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
            
            return passwordRegex.evaluate(with: password)
        }
}

#Preview {
    LoginView()
}
