//
//  ConversationTxtMssg.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 06/03/24.
//

import SwiftUI

struct ConversationTxtMssg: View {
    var msg : String
    var isFromUser : Bool
    var body: some View {
        Text(msg)
            .font(Font.bodyTxt)
            .foregroundStyle(isFromUser ? .txtPrimary : .txtSecondary)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(isFromUser ? .bblPrimary : .bblSecondary)
            .cornerRadiuss(radius: 30, corners: isFromUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
    }
}


