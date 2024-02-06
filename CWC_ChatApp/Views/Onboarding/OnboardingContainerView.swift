//
//  OnboardingContainerView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

enum OnboardingStep : Int{
    case welcome = 0
    case phonenumber = 1
    case verification = 2
    case profile = 3
    case contacts = 4
}
struct OnboardingContainerView: View {
    @Binding var isOnboarding : Bool
    @State var currentStep : OnboardingStep = .welcome
    var body: some View {
        ZStack{
            Color(.bg)
                .ignoresSafeArea()
            
            switch currentStep{
                
            case .welcome:
                WelcomeView(currentStep: $currentStep)
            case .phonenumber:
                PhonenumberView(currentStep: $currentStep)
            case .verification:
                VerificationView(currentStep: $currentStep)
            case .profile:
                CreateProfileView(currentStep: $currentStep)
            case .contacts:
                ContactsView(isOnboarding: $isOnboarding)
            }
        }
    }
}

#Preview {
    OnboardingContainerView(isOnboarding: .constant(true))
}
