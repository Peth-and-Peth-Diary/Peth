//
//  LoginView.swift
//  Peth
//
//  Created by masbek mbp-m2 on 06/08/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var fullName: String = ""
    @State private var userEmail: String = ""
    @State private var isLoggedIn: Bool = false
    @State var userID = ""
    @AppStorage("authID") var authID: String = ""
    
    var body: some View {
        VStack {
            if isLoggedIn {
                ContentView()
//                LogoutButton(isLoggedIn: $isLoggedIn, logoutAction: clearUserData)
            } else {
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        print("Authorisation successful")
                        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                            // Handle successful login here
                            print(appleIDCredential)
                            // User ID
                            let userID = appleIDCredential.user
                            print("User ID: \(userID)")
                            self.userID = userID
                            authID = userID
                            
                            // User's full name
                            if let fullName = appleIDCredential.fullName {
                                let firstName = fullName.givenName ?? ""
                                let lastName = fullName.familyName ?? ""
                                self.fullName = "\(firstName) \(lastName)"
                                
                                print(fullName)
                            }
                            
                            // User's email
                            let userEmail = appleIDCredential.email ?? ""
                            self.userEmail = userEmail
                            print(userEmail)
                            
                            isLoggedIn = true
                            
                            //                            print(" \(self.userEmail) and name : \(fullName)")
                            
                        }
                    case .failure(let error):
                        print("Authorisation failed: \(error.localizedDescription)")
                    }
                }
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(width: 200, height: 50)
            }
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(userID)
        }
        .padding()
    }
    
    // Function to clear user data on logout
    func clearUserData() {
        // Clear user-related data from UserDefaults or any other storage
        UserDefaults.standard.removeObject(forKey: "userFullName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        
        // Perform any other necessary actions for logout, e.g., invalidating tokens, notifying the server, etc.
    }
}


struct LogoutButton: View {
    @Binding var isLoggedIn: Bool
    var logoutAction: () -> Void
    
    var body: some View {
        Button(action: {
            // Perform logout action here
            isLoggedIn = false
            
            // Call the logout action defined in ContentView
            logoutAction()
        }) {
            Text("Logout")
        }
        .padding()
        .background(Color.gray)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
