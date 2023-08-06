//
//  ContentView.swift
//  Peth
//
//  Created by masbek mbp-m2 on 06/08/23.
//

import SwiftUI

struct ContentView: View {
    @State var isShowingProfileModal : Bool = false
    @AppStorage("authID") var authID: String = ""
    
    var body: some View {
        NavigationView{
            ScrollView {
                LazyVStack {
                    ForEach(0...300, id: \.self) { _ in
                        Text("oke")
                    }
                }
            }
            .navigationTitle("Peth's Timeline")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .onTapGesture {
                                isShowingProfileModal = true
                            }
                        //                            .resizable()
                        //                            .frame(width: 24, height: 24)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Image(systemName: "pencil.circle.fill")
                        .padding(.trailing)
                        .onTapGesture {
                            isShowingProfileModal = true
                        }

                }
      
            }
            .sheet(isPresented: $isShowingProfileModal) {
                LogoutButton(isLoggedIn: $isShowingProfileModal, logoutAction: clearUserData)
            }
        }
        
    }
    // Function to clear user data on logout
    func clearUserData() {
        // Clear user-related data from UserDefaults or any other storage
        UserDefaults.standard.removeObject(forKey: "userFullName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        
        authID = ""
        LoginView()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
