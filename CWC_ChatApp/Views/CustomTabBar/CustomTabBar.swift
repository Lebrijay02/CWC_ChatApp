//
//  CustomTabBar.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

enum Tabs : Int{
    case chats = 0
    case contacts = 1
}

struct CustomTabBar: View {
    @Binding var selectedTab : Tabs
    var body: some View {
        HStack{
            Button {
                selectedTab = .chats
            } label: {
                CustomTabBarButton(buttonText: "Chats", imageName: "bubble.left", isActive: selectedTab == .chats)
            }
            .tint(.iconSecondary)
            
            Button {
                //
            } label: {
                VStack{
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    Text("Chats")
                        .font(.tabBar)
                }
            }
            .tint(.iconPrimary)
            
            Button {
                selectedTab = .contacts
            } label: {
                CustomTabBarButton(buttonText: "Contacts", imageName: "person", isActive: selectedTab == .contacts)
            }
            .tint(.iconSecondary)
        }
        .frame(height: 82)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.chats))
}
