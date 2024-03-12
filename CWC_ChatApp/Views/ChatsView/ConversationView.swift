//
//  ConversationView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 15/02/24.
//

import SwiftUI

struct ConversationView: View {
    @Binding var isChatShowing : Bool
    //image'''
    @State var selectedImage : UIImage?
    @State var isPickerShowing = false
    @State var isSourceMenuShowing = false
    @State var source : UIImagePickerController.SourceType = .photoLibrary
    //'''image
    @State var chatMessage = ""
    @State var participants = [User]()
    @EnvironmentObject var chatViewModel : ChatViewModel
    @EnvironmentObject var contactsViewModel : ContactsViewModel
    //var user : User
    
    var body: some View {
        VStack(spacing: 0){
            //header
            ZStack{
                Color(.bg)
                    .ignoresSafeArea()
                HStack{
                    VStack(alignment: .leading){
                        HStack{
                            //back
                            Button {
                                isChatShowing = false
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                                    .tint(Color.txtChatHeading)
                            }
                            //recipient
                            if participants.count == 0{
                                Text("New Message")
                                    .font(.chatHeading)
                                    .foregroundStyle(Color.txtChatHeading)
                            }
                        }
                        .padding(.bottom, 16)
                        //name
                        //Text(user.firstname ?? "nil")
                        if !participants.isEmpty{
                            let participant = participants.first
                            Text("\(participant?.firstname ?? "nil") \(participant?.lastname ?? "nil")")
                                .font(.chatHeading)
                                .foregroundStyle(.txtChatHeading)
                        }else{
                            Text("Recipiant")
                                .font(.bodyTxt)
                                .foregroundStyle(.txtInput)
                        }
                    }
                    Spacer()
                    if !participants.isEmpty{
                        let participant = participants.first
                        //pfp
                        ProfilePicView(user: participant!)
                    }else{
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.bblPrimary)
                        })
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 104)

            //log
            ScrollViewReader{ proxy in
                ScrollView {
                    VStack(spacing: 24){
                        ForEach(Array(chatViewModel.messages.enumerated()), id : \.element){index, msg in
                            let isFromUser = msg.senderid == AuthViewModel.getLoggedInUserId()
                            HStack{
                                if isFromUser{
                                    //Time
                                    Text(DateHelper.chatTimeStamp(date: msg.timestamp))
                                        .font(Font.smallTxt)
                                        .foregroundStyle(.time)
                                        .padding(.trailing)
                                    Spacer()
                                }
                                //message
                                if msg.imgurl != ""{
                                    //photo
                                    ConversationPhotoMssg(imageUrl: msg.imgurl!, isFromUser: isFromUser)
                                }else{
                                    //text
                                    ConversationTxtMssg(msg: msg.msg!, isFromUser: isFromUser)
                                }
                                if !isFromUser{
                                    Spacer()
                                    //Time
                                    Text(DateHelper.chatTimeStamp(date: msg.timestamp))
                                        .font(Font.smallTxt)
                                        .foregroundStyle(.time)
                                        .padding(.trailing)
                                }
                            }
                            .id(index)
                        }
                    }
                    //.padding(.horizontal)
                    .padding()
                }
                .onChange(of: chatViewModel.messages.count) { newCount, V in
                    withAnimation{
                        proxy.scrollTo(newCount)
                        
                    }
                }
            }
            //mesagebar
            HStack(spacing: 15){
                //camera
                Button {
                    isSourceMenuShowing = true
                } label: {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .tint(.iconSecondary)
                }
                //textfield
                ZStack{
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.datePill)
                    
                    if selectedImage != nil{
                        //display image in mssg bar
                        Text("Image")
                            .padding(10)
                            .font(.bodyTxt)
                            .foregroundStyle(.txtInput)
                        HStack{
                            Spacer()
                            Button {
                                //delete iamge
                                selectedImage = nil
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .tint(.txtInput)
                            }
                        }
                        .padding(.trailing, 10)
                    }else{
                        TextField("", text: $chatMessage)
                            .padding(10)
                            .font(.bodyTxt)
                            .foregroundStyle(.txtInput)
                            .placeholder(when: chatMessage.isEmpty) {
                                Text("Aa")
                                    .foregroundColor(.txtInput)
                                    .font(.bodyTxt)
                                    .padding(10)
                            }
                        /*
                         HStack{
                             Spacer()
                             Button {
                                 //
                             } label: {
                                 Image(systemName: "face.smiling.inverse")
                                     .resizable()
                                     .scaledToFit()
                                     .frame(width: 24, height: 24)
                                     .tint(.txtInput)
                             }
                         }
                         .padding(.trailing, 10)
                         */
                    }
                }
                .frame(height: 44)
                .padding(.horizontal, 5)
                //send
                Button {
                    //check if image selected
                    if selectedImage == nil{
                        //clean text
                        chatMessage = chatMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                        //send mssg
                        chatViewModel.sendMessage(msg: chatMessage)
                        //clear txtbox
                        chatMessage = ""
                    }else{
                        //send image
                        chatViewModel.sendPhotoMessage(img: selectedImage!)
                        //clear iamge saved
                        selectedImage = nil
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .tint(.iconPrimary)
                }
                .disabled(chatMessage.trimmingCharacters(in: .whitespacesAndNewlines) == "" && selectedImage == nil)
            }
            .disabled(participants.count == 0)
            .padding(.horizontal)
            .frame(height: 76)

        }
        .onAppear{
            //call chat view model to retrieve all chat mssgs
            chatViewModel.getMessages()
            // try to get other participants UIDs
            let ids = chatViewModel.getparticipantIds()
            print("ids: \(ids)")
            self.participants = contactsViewModel.getParticipants(ids: ids)
            print("iparticipantsds: \(self.participants)")
        }
        .onDisappear{
            chatViewModel.closeConversationView()
        }
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
