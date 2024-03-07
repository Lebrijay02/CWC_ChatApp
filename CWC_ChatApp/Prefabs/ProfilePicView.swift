//
//  ProfilePicView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 15/02/24.
//

import SwiftUI

struct ProfilePicView: View {
    var user : User
    var body: some View {
        ZStack{
            //check if user has pic
            if user.photo != nil{
                //check if cache exists
                if let cacheImage = ChacheService.getImage(key: user.photo!){
                    //if in, use image in cache
                    cacheImage
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                }else{
                    //otherwise
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
                                .onAppear{
                                    //save image in cache
                                    ChacheService.setImage(image: image, key: user.photo!)
                                }

                        case .failure:
                            //couldnt fetch
                            ZStack{
                                Circle()
                                    .foregroundStyle(.white)
                                Text(user.firstname?.prefix(1) ?? "U")
                                    .bold()
                                    .foregroundStyle(.txtSecondary)
                            }
                        @unknown default:
                            //couldnt fetch
                            ZStack{
                                Circle()
                                    .foregroundStyle(.white)
                                Text(user.firstname?.prefix(1) ?? "U")
                                    .bold()
                                    .foregroundStyle(.txtSecondary)

                            }
                        }
                    }
                }
            }else{
                ZStack{
                    Circle()
                        .foregroundStyle(.white)
                    Text(user.firstname?.prefix(1) ?? "U")
                        .bold()
                        .foregroundStyle(.txtSecondary)
                }
            }
            Circle()
                .stroke(Color(.createProfileBorder),lineWidth: 2)
        }
        .frame(width: 44, height: 44)
    }
}

