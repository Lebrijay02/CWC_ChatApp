//
//  VerificationView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

struct VerificationView: View {
    @Binding var currentStep : OnboardingStep
    @State var verifCode = ""
    var body: some View {
        VStack{
            Text("Verification")
                .font(.titleTxt)
                .padding(.top, 52)
            Text("Enter the 6-digit verification code we sent to your device.")
                .font(.bodyTxt)
                .padding(.top, 12)
            ZStack{
                Rectangle()
                    .frame(height: 56)
                    .foregroundStyle(.inputField)
                TextField("", text: $verifCode)
                    .font(.bodyTxt)
            }
            .padding(.top, 34)
            Spacer()
            Button{
                //send verif to fb
                AuthViewModel.verifyCode(code: verifCode) { error in
                    if error == nil{
                        currentStep = .profile
                    }else{
                        
                    }
                }
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
    VerificationView(currentStep: .constant(.verification))
}
