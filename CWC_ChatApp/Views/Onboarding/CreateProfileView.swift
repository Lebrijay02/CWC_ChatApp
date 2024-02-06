//
//  ProfileView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

struct CreateProfileView: View {
    @Binding var currentStep : OnboardingStep
    @State var fName = ""
    @State var lName = ""
    
    @State var selectedImage : UIImage?
    @State var isPickerShowing = false
    
    @State var isSourceMenuShowing = false
    @State var source : UIImagePickerController.SourceType = .photoLibrary
    
    @State var isButtonDisabled = false
    
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
                isSourceMenuShowing = true
            } label: {
                ZStack{
                    if selectedImage != nil{
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                        
                    }else{
                        Circle()
                            .foregroundStyle(.white)
                        Image(systemName: "camera.fill")
                            .tint(.iconInput)
                    }
                    Circle()
                        .stroke(Color(.createProfileBorder),lineWidth: 2)
                }
                
                .frame(width: 134, height: 134)
            }

            Spacer()
            
            TextField("First Name", text: $fName)
                .textFieldStyle(CreateProfileTxtFieldStyle())
                .foregroundStyle(.txtInput)
            TextField("Last Name", text: $lName)
                .textFieldStyle(CreateProfileTxtFieldStyle())
                .foregroundStyle(.txtInput)
            
            Spacer()
            
            Button{
                isButtonDisabled = true
                DatabaseService().setUserProfile(firstName: fName, lastName: lName, image: selectedImage) { isSuccess in
                    if isSuccess{
                        currentStep = .contacts
                    }else{
                        //show error to user
                    }
                    isButtonDisabled = true
                }
            } label: {
                Text(isButtonDisabled ? "Uploading" : "Save")
            }
            .disabled(isButtonDisabled)
            .buttonStyle(OnBoardingButtonStyle())
            .padding(.bottom, 87)
        }
        .padding(.horizontal)
        .confirmationDialog("From where?", isPresented: $isSourceMenuShowing, actions: {
            Button {
                self.source = .photoLibrary
                isPickerShowing = true
            } label: {
                Text("Photo Library")
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                Button {
                    self.source = .camera
                    isPickerShowing = true
                } label: {
                    Text("Camera")
                }
            }
        })
        .sheet(isPresented: $isPickerShowing) {
            //show image pickeer
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing, source: source)
        }

    }
}

#Preview {
    CreateProfileView(currentStep: .constant(.profile))
}
