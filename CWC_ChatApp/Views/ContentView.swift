//
//  ContentView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

struct ContentView: View {
    //detects when app state changes
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var chatViewModel : ChatViewModel
    @EnvironmentObject var contactsViewModel : ContactsViewModel
    @State var selectedTab : Tabs = .contacts
    @State var isOnboarding = !AuthViewModel.isUserLoggedIn()
    @State var isChatShowing = false
    var body: some View {
        ZStack{
            Color(.bg)
                .ignoresSafeArea()
            VStack {
                switch selectedTab {
                case .chats:
                    ChatsListView(isChatShowing: $isChatShowing)
                case .contacts:
                    ContactsListView(isChatShowing: $isChatShowing)
                }
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .onAppear{
            if !isOnboarding{
                //user already onboarded
                contactsViewModel.getLocalContacts()
            }
        }
        .fullScreenCover(isPresented: $isOnboarding){
            //
        } content:{
            OnboardingContainerView(isOnboarding: $isOnboarding)
        }
        .fullScreenCover(isPresented: $isChatShowing) {
            //
        } content:{
            ConversationView(isChatShowing: $isChatShowing)
        }
        .onChange(of: scenePhase) { oldValue, newPhase in
            if newPhase == .active{
                print("active")
            }else if newPhase == .inactive{
                print("inactive")
            }else if newPhase == .background{
                print("background")
                chatViewModel.closeChatListView()
            }
        }

    }
}

#Preview {
    ContentView()
}

