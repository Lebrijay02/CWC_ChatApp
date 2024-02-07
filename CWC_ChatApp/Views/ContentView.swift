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
        ZStack{
            Color(.bg)
                .ignoresSafeArea()
            VStack {
                switch selectedTab {
                case .chats:
                    ChatsListView()
                case .contacts:
                    ContactsListView()
                }
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
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

