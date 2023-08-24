//
//  TextView.swift
//  Peth
//
//  Created by masbek mbp-m2 on 07/08/23.
//

import SwiftUI
import RichTextKit
import Combine

struct TextView: View {
    
    @State private var text = NSAttributedString.empty
    
    @State private var isShowingLogin: Bool = false
    @State var thoughts = ""
    @State var wordCounter: Int = 0
    @State var counterColor: Color = .blue
    
    @StateObject var context = RichTextContext()
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("authID") var authID: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("textLimit") var textLimit = 10
    
    var body: some View {
        if isLoggedIn {
            NavigationView{
                NavigationStack {
                    //                    RichTextEditor(text: $text, context: context) {
                    //                        $0.textContentInset = CGSize(width: 10, height: 20)
                    //                    }
                    //                    .background(Material.regular)
                    //                    .cornerRadius(5)
                    //                    .focusedValue(\.richTextContext, context)
                    //                    .padding()
                    //
                    //                    RichTextKeyboardToolbar(
                    //                        context: context,
                    //                        leadingButtons: {},
                    //                        trailingButtons: {}
                    //                    )
                    Form{
                        Section {
                            TextEditor(text: $thoughts)
                                .frame(minHeight: 30, alignment: .leading)
                                .cornerRadius(6.0)
                                .lineSpacing(5)
                                .multilineTextAlignment(.leading)
                                .padding(9)
                            
                            HStack {
                                Spacer()
                                Text("\(wordCounter) / \(textLimit == Int.max ? "∞" : String(textLimit))")
                                    .font(.caption)
                                    .foregroundColor(counterColor)
//                                    .padding(.trailing)
                                    
                            }
                        }
                    }
                    
                }
                .onReceive(Just(thoughts)) { _ in
                    wordCounter = thoughts.split(whereSeparator: \.isWhitespace).count
                    if textLimit != Int.max {
                        if thoughts.split(whereSeparator: \.isWhitespace).count
                            > textLimit {
                            counterColor = .red
                            let words = thoughts.split { $0.isWhitespace }
                            thoughts = words.prefix(textLimit).joined(separator: " ")
                        }
                    }
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
                                await storePost(authID: authID, post: thoughts)
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
