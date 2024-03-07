//
//  ConversationPhotoMssg.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 06/03/24.
//

import SwiftUI

struct ConversationPhotoMssg: View {
    var imageUrl : String
    var isFromUser : Bool
    var body: some View {
        if let cacheImage = ChacheService.getImage(key: imageUrl){
            //if in, use image in cache
            cacheImage
                .resizable()
                .scaledToFill()
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(isFromUser ? .bblPrimary : .bblSecondary)
                .cornerRadiuss(radius: 30, corners: isFromUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
        }else{
            //download image
            let photoUrl = URL(string: imageUrl)

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
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(isFromUser ? .bblPrimary : .bblSecondary)
                        .cornerRadiuss(radius: 30, corners: isFromUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                        .onAppear{
                            //cache
                            ChacheService.setImage(image: image, key: imageUrl)
                        }
                case .failure:
                    //couldnt fetch
                    ConversationTxtMssg(msg: "Couldnt load image", isFromUser: isFromUser)
                @unknown default:
                    //couldnt fetch
                    ConversationTxtMssg(msg: "Couldnt load image", isFromUser: isFromUser)
                }
            }
        }
    }
}

