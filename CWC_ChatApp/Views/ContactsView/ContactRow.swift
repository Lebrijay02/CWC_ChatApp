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
            ZStack{
                //check if user has pic
                if user.photo != nil{
                    let photoUrl = URL(string: user.photo ?? "")

                    AsyncImage(url: photoUrl){phase in
                        switch phase{
                        case .empty:
                            //fetching
                            ProgressView()
                        case .success(let image):
                            //display image
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())

                        case .failure:
                            //couldnt fetch
                            ZStack{
                                Circle()
                                    .foregroundStyle(.blue)
                                Text(user.firstname?.prefix(1) ?? "U")
                                    .bold()
                            }
                        }
                    }
                }else{
                    ZStack{
                        Circle()
                            .foregroundStyle(.white)
                        Text(user.firstname?.prefix(1) ?? "U")
                            .bold()
                    }
                }
                Circle()
                    .stroke(Color(.createProfileBorder),lineWidth: 2)
            }
            .frame(width: 44, height: 44)
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
