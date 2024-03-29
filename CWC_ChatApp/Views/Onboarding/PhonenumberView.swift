//
//  PhonenumberView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI
import Combine

struct PhonenumberView: View {
    @Binding var currentStep : OnboardingStep
    @State var phoneNumber = ""
    var body: some View {
        VStack{
            Text("Verification")
                .font(.titleTxt)
                .padding(.top, 52)
            Text("Enter your Mobile number below. We'll send you a verification code after.")
                .font(.bodyTxt)
                .padding(.top, 12)
            ZStack{
                Rectangle()
                    .frame(height: 56)
                    .foregroundStyle(.inputField)
                HStack{
                    TextField("", text: $phoneNumber)
                        .font(.bodyTxt)
                        .foregroundStyle(.txtInput)
                        .keyboardType(.decimalPad)
                        .onReceive(Just(phoneNumber)) { _ in
                            TextHelper.applyPatternOnNumbers(&phoneNumber, pattern: "+## ## #### ####", replacementCharacter: "#")
                        }
                        .placeholder(when: phoneNumber.isEmpty) {
                            Text("e.g +52 81 1482 3428")
                                .foregroundColor(.txtInput)
                                .font(.bodyTxt)
                        }
                    Spacer()
                    Button(action: {
                        phoneNumber = ""
                    }, label: {
                        Image(systemName: "multiply.circle.fill")
                            .frame(width: 19, height: 19)
                            .tint(.iconInput)
                    })
                }
                .padding()
            }
            .padding(.top, 34)
            Spacer()
            Button{
                //send phone ti fb auth
                AuthViewModel.sendPhoneNumber(phone: phoneNumber) { error in
                    if error == nil{
                        currentStep = .verification
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
    PhonenumberView(currentStep: .constant(.phonenumber))
}
