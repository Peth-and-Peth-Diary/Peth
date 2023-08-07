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
    
    @AppStorage("username") var username: String = ""
    
    
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
            .navigationBarTitle("Trip", displayMode: .inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            username = usernameInput
                            dismiss()
                        }
                    ) {
                        Text("Done")
                            .foregroundColor(Color.accentColor)
                        
                            .padding(.horizontal)
                    }
                }
            }
            .toolbarBackground(Color(UIColor.systemGray6), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
        }
    }
}

struct InputUsernameModal_Previews: PreviewProvider {
    static var previews: some View {
        InputUsernameModal()
    }
}
