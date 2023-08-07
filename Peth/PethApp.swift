//
//  PethApp.swift
//  Peth
//
//  Created by masbek mbp-m2 on 06/08/23.
//

import SwiftUI

@main
struct PethApp: App {
    @AppStorage("authID") var authID: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if (isLoggedIn) {
                ContentView()
            }
            else {
                LoginView()
            }
        }
    }
}
