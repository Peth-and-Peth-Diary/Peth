//
//  TextView.swift
//  Peth
//
//  Created by masbek mbp-m2 on 07/08/23.
//

import SwiftUI
import RichTextKit

struct TextView: View {
    
    @State
    private var text = NSAttributedString.empty
    
    @StateObject
    var context = RichTextContext()
    @Environment(\.dismiss) var dismiss
    @AppStorage("authID") var authID: String = ""
    @State private var isShowingLogin: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        if isLoggedIn {
            NavigationView{
                NavigationStack {
                    RichTextEditor(text: $text, context: context) {
                        $0.textContentInset = CGSize(width: 10, height: 20)
                    }
                    .background(Material.regular)
                    .cornerRadius(5)
                    .focusedValue(\.richTextContext, context)
                    .padding()
                    
                    RichTextKeyboardToolbar(
                        context: context,
                        leadingButtons: {},
                        trailingButtons: {}
                    )
                }
                .background(Color.primary.opacity(0.15))
                .navigationBarTitle("Peth It", displayMode: .inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action:{
                            dismiss()
                        }){
                            Text("Cancel")
                                .foregroundColor(Color.accentColor)
                                .padding(.horizontal)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action:{
                            Task{
                                await storePost(authID: authID, post: text)
                            }
                            dismiss()
                        }){
                            Text("Post")
                                .foregroundColor(Color.accentColor)
                                .padding(.horizontal)
                        }
                    }
                }
                
            }
        } else {
            LoginView()
        }
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
