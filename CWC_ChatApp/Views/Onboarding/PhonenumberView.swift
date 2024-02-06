//
//  PhonenumberView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

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
                    TextField("e.g +52 81 1482 3428", text: $phoneNumber)
                        .font(.bodyTxt)
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
                currentStep = .verification
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
