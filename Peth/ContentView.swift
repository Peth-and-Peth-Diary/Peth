//
//  ContentView.swift
//  Peth
//
//  Created by masbek mbp-m2 on 06/08/23.
//

import SwiftUI

struct TimelineView: View {
    @State var isShowingProfileModal : Bool = false
    @State var isShowingEditorModal: Bool = false
    @Binding var isShowingInputUsernameModal: Bool
    
    @AppStorage("authID") var authID: String = ""
    @AppStorage("username") var username: String = ""
    
    @State var posts : [Posts] = []
    
    var body: some View {
        NavigationView{
            ScrollView{
                ForEach(posts,  id: \.id) { post in
                    LazyVStack(alignment: .leading) {
                        HStack{
                            Text(post.username)
                                .font(.headline)
                            Text("·")
                            Text(post.updated_at)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        Text(post.post)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                        Divider()
                    }
                    .padding()
                }
            }            .navigationTitle("Peth's Timeline")
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
                    ProfileView()
                }
                .sheet(isPresented: $isShowingEditorModal, onDismiss: {
                    fetchPosts()
                    // code to execute when sheet dismiss
                }, content: {
                    TextView()
                })
                .sheet(isPresented: $isShowingInputUsernameModal, onDismiss: {
                    fetchPosts()
                }, content: {
                    InputUsernameModal()
                        .presentationDetents([.height(UIScreen.main.bounds.size.height / 2) , .medium, .large])
                        .presentationDragIndicator(.automatic)
                        .interactiveDismissDisabled()
                    
                })
                .refreshable {
                    fetchPosts()
                }
            
        }
        .onAppear{
            fetchPosts()
        }
    }
    
    func fetchPosts() {
        getPosts{ result in
            switch result {
            case .success(let post):
                posts = post
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

struct ContentView : View {
    @State var isShowingInputUsernameModal: Bool = false
    @AppStorage("username") var username: String = ""
    
    var body: some View {
        TimelineView(isShowingInputUsernameModal: $isShowingInputUsernameModal)
            .onAppear{
                print("real value: \(username)")
                print(username == "")
                if (username == "") {
                    isShowingInputUsernameModal = true
                }
            }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
