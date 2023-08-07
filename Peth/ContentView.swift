//
//  ContentView.swift
//  Peth
//
//  Created by masbek mbp-m2 on 06/08/23.
//

import SwiftUI

struct ContentView: View {
    @State var isShowingProfileModal : Bool = false
    @State var isShowingEditorModal: Bool = false
    @State var isShowingInputUsernameModal: Bool = false
    
    @AppStorage("authID") var authID: String = ""
    @AppStorage("username") var username: String = ""
    
    var body: some View {
        NavigationView{
            List{
                ForEach(1...100,  id: \.self) {_ in
                    VStack(alignment: .leading) {
                        Text(username)
                            .font(.headline)
                        Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
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
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Image(systemName: "square.and.pencil")
                        .padding(.trailing)
                        .onTapGesture {
                            isShowingEditorModal = true
                        }
                    
                }
                
            }
            .sheet(isPresented: $isShowingProfileModal) {
                LogoutButton(isLoggedIn: $isShowingProfileModal, logoutAction: clearUserData)
            }
            .sheet(isPresented: $isShowingEditorModal) {
                TextView()
            }
            .sheet(isPresented: $isShowingInputUsernameModal) {
                InputUsernameModal()
                    .presentationDetents([.height(UIScreen.main.bounds.size.height / 2) , .medium, .large])
                    .presentationDragIndicator(.automatic)
                    .interactiveDismissDisabled()
                
            }
            .onAppear(){
                if (username == "") {
                    isShowingInputUsernameModal = true
                }
            }

        }
        
    }
    // Function to clear user data on logout
    func clearUserData() {
        // Clear user-related data from UserDefaults or any other storage
        UserDefaults.standard.removeObject(forKey: "userFullName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        
        authID = ""
        username = ""
        LoginView()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
