//
//  InputUsernameModal.swift
//  Peth
//
//  Created by masbek mbp-m2 on 07/08/23.
//

import SwiftUI

struct InputUsernameModal: View {
    @Environment(\.dismiss) var dismiss
    @State var usernameInput: String = ""
    
    @AppStorage("authID") var authID: String = ""
    @AppStorage("username") var username: String = AuthData.username
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create Your Unique Username!")
                TextField("Username", text: $usernameInput)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                
                Button(
                    action: {
                        username = usernameInput
                        Task{
                            await storeAuth(authID: authID, username: username)
                        }
                        dismiss()
                    }
                ) {
                    Spacer()
                    Text("Save!")
                    Spacer()
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(Color.white)
                .padding(.horizontal, 14)
            }
            .padding(.horizontal)
            .navigationBarTitle("Username", displayMode: .inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            username = usernameInput
//                            AuthData.setValue(username)
                            Task{
                                await storeAuth(authID: authID, username: usernameInput)
                            }
                            dismiss()
                        }
                    ) {
                        Text("Done")
                            .fontWeight(.bold)
//                            .padding(.horizontal)
                    }
                    .disabled(usernameInput == "")
                }
                
            }
//            .toolbarBackground(Color(UIColor.systemGray6), for: .navigationBar)
//            .toolbarBackground(.visible, for: .navigationBar)
            
        }
    }
}

struct InputUsernameModal_Previews: PreviewProvider {
    static var previews: some View {
        InputUsernameModal()
    }
}
