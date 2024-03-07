//
//  CWC_ChatAppApp.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

@main
struct CWC_ChatAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate //: AppDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ContactsViewModel())
                .environmentObject(ChatViewModel())
        }
    }
}
