//
//  ContentView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab : Tabs = .contacts
    @State var isOnboarding = !AuthViewModel.isUserLoggedIn()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                //.font(.custom("", size: <#T##CGFloat#>))
            Spacer()
            CustomTabBar(selectedTab: $selectedTab)
        }
        .fullScreenCover(isPresented: $isOnboarding){
            //
        } content:{
            OnboardingContainerView(isOnboarding: $isOnboarding)
        }
    }
}

#Preview {
    ContentView()
}

