//
//  ContactRow.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 06/02/24.
//

import SwiftUI

struct ContactRow: View {
    var user : User
    var body: some View {
        HStack(spacing: 24){
            ProfilePicView(user: user)
            VStack(alignment: .leading){
                Text("\(user.firstname ?? "") \(user.lastname ?? "")")
                    .font(.button)
                    .foregroundStyle(.txtPrimary)
                Text(user.phone ?? "")
                    .font(.bodyTxt)
                    .foregroundStyle(.txtInput)
            }
            Spacer()
        }
    }
}

#Preview {
    ContactRow(user: User())
}
