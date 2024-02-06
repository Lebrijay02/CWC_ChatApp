//
//  WelcomeView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var currentStep : OnboardingStep
    var body: some View {
        VStack{
            Spacer()
            Image("welcome")
            Text("Welcome to Chat App")
                .font(.titleTxt)
                .padding(.top, 32)
            Text("Simple and fuss-free chat experiance")
                .font(.bodyTxt)
                .padding(.top, 8)
            Spacer()
            Button{
                currentStep = .phonenumber
            } label: {
                Text("Get Started")
            }
            .buttonStyle(OnBoardingButtonStyle())
            Text("By tapping 'Get Started', you agree to our Privacy Policy.")
                .font(.smallTxt)
                .padding(.top, 14)
                .padding(.bottom, 61)
        }
        .padding(.horizontal)
    }
}

#Preview {
    WelcomeView(currentStep: .constant(.welcome))
}
