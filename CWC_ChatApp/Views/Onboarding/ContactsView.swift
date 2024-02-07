//
//  ContactsView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

struct ContactsView: View {
    @Binding var isOnboarding : Bool
    var body: some View {
        VStack{
            Spacer()
            Image("allSet")
            Text("Awesome")
                .font(.titleTxt)
                .padding(.top, 32)
            Text("Continue to start chatting with your friends.")
                .font(.bodyTxt)
                .padding(.top, 8)
            Spacer()
            Button{
                isOnboarding = false
            } label: {
                Text("Next")
            }
            .buttonStyle(OnBoardingButtonStyle())
            .padding(.bottom, 87)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContactsView(isOnboarding: .constant(true))
}
