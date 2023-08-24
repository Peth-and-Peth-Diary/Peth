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
    @State private var isAnimating: Bool = true
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State var userID = ""
    @AppStorage("authID") var authID: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Peth")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Text("Your space to share thoughts, untethered by likes or comments. Here, your words take center stage, not the numbers. Join us and liberate your ideas")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            Text("Start With")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(isAnimating ? .red : .blue) // You can set the initial color here
//                .animation(Animation.easeInOut(duration: 1).repeatForever())
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        withAnimation(.easeInOut(duration: 1)) {
                            self.isAnimating.toggle()
                        }
                    }
                }
            
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
                        getCredentialState(forUserID: userID) { credentialState, error in
                            if let error = error {
                                print("Error: \(error)")
                            } else {
                                switch credentialState {
                                case .authorized:
                                    print("User is authorized.")
                                case .revoked:
                                    print("User's credential has been revoked.")
                                case .notFound:
                                    print("User's credential not found.")
                                case .transferred:
                                    print("user's transferred")
                                @unknown default:
                                    print("Unknown credential state.")
                                }
                            }
                        }
                        
                        isLoggedIn = true
                        ContentView()
                        
                    }
                case .failure(let error):
                    print("Authorisation failed: \(error.localizedDescription)")
                }
            }
            .signInWithAppleButtonStyle(.whiteOutline)
            .frame(width: 200, height: 50)
        }
        .padding()
    }
    
    func getCredentialState(
        forUserID userID: String,
        completion: @escaping (ASAuthorizationAppleIDProvider.CredentialState, Error?) -> Void
    ) {
        // Example implementation
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) { credentialState, error in
            completion(credentialState, error)
        }
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
