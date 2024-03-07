//
//  ChatsListView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 06/02/24.
//

import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var chatViewModel : ChatViewModel
    @EnvironmentObject var contactsViewModel : ContactsViewModel
    @Binding var isChatShowing : Bool
    var body: some View {
        VStack{
            HStack{
                Text("Chats")
                    .font(.pageTitle)
                Spacer()
                Button(action: {
                    //
                }, label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .tint(.iconSecondary)
                })
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            if !chatViewModel.chats.isEmpty{
                List(chatViewModel.chats){chat in
                    Button {
                        chatViewModel.selectedChat = chat
                        isChatShowing = true
                    } label: {
                        ChatListRow(chat: chat, otherParticipants: contactsViewModel.getParticipants(ids: chat.participantids))

                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .padding(.top, 10)
            }else{
                Spacer()
                Image("noChats")
                Text("Hmm... No chats here yet!")
                    .font(.titleTxt)
                    .padding(.top, 32)
                Text("Chat a friend to get started")
                    .font(.bodyTxt)
                    .padding(.top, 8)
                Spacer()
            }
        }
    }
}

#Preview {
    ChatsListView(isChatShowing: .constant(false))
}
