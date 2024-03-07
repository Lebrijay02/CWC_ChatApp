//
//  ChatListRow.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 23/02/24.
//

import SwiftUI

struct ChatListRow: View {
    var chat : Chat
    var otherParticipants : [User]?
    var body: some View {
        HStack(spacing: 24){
            //assume at least one other is in chat
            let participant = otherParticipants!.first
            //profile image of participants
            if participant != nil{
                ProfilePicView(user: participant!)
            }
            VStack(alignment: .leading){
                Text(participant == nil ? "Unknown" : "\(participant!.firstname ?? "") \(participant!.lastname ?? "")")
                    .font(.button)
                    .foregroundStyle(.txtPrimary)
                //last message
                Text(chat.lastmsg ?? "")
                    .font(.bodyTxt)
                    .foregroundStyle(.txtInput)
            }
            Spacer()
            //time stamp
            Text(chat.updated == nil ? "" : DateHelper.chatTimeStamp(date: chat.updated!))
                .font(.bodyTxt)
                .foregroundStyle(.txtInput)
        }
    }
}
