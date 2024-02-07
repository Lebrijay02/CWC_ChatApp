//
//  VerificationView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI
import Combine

struct VerificationView: View {
    @Binding var currentStep : OnboardingStep
    @Binding var isOnboarding : Bool
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
                HStack{
                    TextField("", text: $verifCode)
                        .font(.bodyTxt)
                        .keyboardType(.numberPad)
                        .foregroundStyle(.txtInput)
                        .onReceive(Just(verifCode)) { _ in
                            TextHelper.limitText(&verifCode, 6)
                        }
                        .placeholder(when: verifCode.isEmpty) {
                            Text("* * * * * *")
                                .foregroundColor(.txtInput)
                                .font(.bodyTxt)
                        }
                    Spacer()
                    Button(action: {
                        verifCode = ""
                    }, label: {
                        Image(systemName: "multiply.circle.fill")
                            .frame(width: 19, height: 19)
                            .tint(.iconInput)
                    })
                }
                .padding()
            }
            //.padding()
            .padding(.top, 34)
            Spacer()
            Button{
                //send verif to fb
                AuthViewModel.verifyCode(code: verifCode) { error in
                    if error == nil{
                        //check if urser exists
                        DatabaseService().checkUserProfile { exists in
                            if exists{
                                isOnboarding = false
                            }else{
                                //move to profile creation
                                currentStep = .profile
                            }
                        }
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
    VerificationView(currentStep: .constant(.verification), isOnboarding: .constant(true))
}
