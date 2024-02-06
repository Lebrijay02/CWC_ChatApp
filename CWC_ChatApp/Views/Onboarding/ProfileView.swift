//
//  ProfileView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

struct ProfileView: View {
    @Binding var currentStep : OnboardingStep
    @State var fName = ""
    @State var lName = ""
    var body: some View {
        VStack{
            Text("Setup your Profile")
                .font(.titleTxt)
                .padding(.top, 52)
            Text("Just a few more details to get started")
                .font(.bodyTxt)
                .padding(.top, 12)
            Spacer()
            Button {
                //
            } label: {
                ZStack{
                    Circle()
                        .foregroundStyle(.white)
                    Circle()
                        .stroke(Color(.createProfileBorder),lineWidth: 2)
                    Image(systemName: "camera.fill")
                        .tint(.iconInput)
                }
                .frame(width: 134, height: 134)
            }

            Spacer()
            
            TextField("First Name", text: $fName)
                .textFieldStyle(CreateProfileTxtFieldStyle())
            TextField("Last Name", text: $lName)
                .textFieldStyle(CreateProfileTxtFieldStyle())
            
            Spacer()
            
            Button{
                currentStep = .contacts
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
    ProfileView(currentStep: .constant(.profile))
}
