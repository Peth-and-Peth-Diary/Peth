//
//  ProfileView.swift
//  Peth
//
//  Created by masbek mbp-m2 on 07/08/23.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("username") var username: String = AuthData.username
    
    @State var usernameInput: String = ""
    
    @AppStorage("authID") var authID: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var store = Store()
    
    var body: some View {
        if isLoggedIn {
            NavigationStack{
                List{
                    VStack{
                        NavigationLink {
                            Form{
                                TextField("Username", text: $username)
                                
                                Section {
                                    Button(
                                        action: {
                                            print(username)
//                                            username = usernameInput
                                            Task{
                                                await storeAuth(authID: authID, username: username)
                                            }
                                            dismiss()
                                            
                                        }
                                    ) {
                                        Text("Save")
                                    }
                                    .foregroundColor(.blue)
                                }
                            }
                        } label: {
                            Text(username)
                                .font(.body)
                            
                        }
                    }
                    HStack{
                        Text("Logout")
                            .font(.body)
                            .foregroundColor(.red)
                    }
                    .onTapGesture{
                        KeychainItem.deleteUserIdentifierFromKeychain(userID: authID)
                        print(KeychainItem.currentUserIdentifier)
                        // Clear user-related data from UserDefaults or any other storage
                        UserDefaults.standard.removeObject(forKey: "userFullName")
                        UserDefaults.standard.removeObject(forKey: "userEmail")
                        
                        
                        authID = ""
                        //                    username = ""
                        isLoggedIn = false
                        dismiss()
                        LoginView()
                        
                    }
                    Section {
                        ForEach(store.products, id: \.id) {
                            product in
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                                Text(product.displayName)
                                Spacer()
                                // 3:
                                Button("\(product.displayPrice)") {
                                    Task {
                                        try await store.purchase(product)
                                    }
                                }
                            }
                        }
                    }
                    
                    
                }
                .navigationBarTitle("Account", displayMode: .inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(
                            action: {
                                dismiss()
                            }
                        ) {
                            Text("Done")
                                .fontWeight(.bold)
                            //                                .padding()
                        }
                    }
                    
                }
                //                .toolbarBackground(Color(UIColor.systemGray6), for: .navigationBar)
                //                .toolbarBackground(.visible, for: .navigationBar)
            }
        }else {
            LoginView()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
