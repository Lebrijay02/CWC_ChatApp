//
//  CustomTabBarButton.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import SwiftUI

struct CustomTabBarButton: View {
    var buttonText : String
    var imageName : String
    var isActive : Bool
    
    var body: some View {
        GeometryReader{ geo in
            if isActive{
                Rectangle()
                    .foregroundStyle(.iconPrimary)
                    .frame(width: geo.size.width/2, height: 4)
                    .padding(.leading, geo.size.width/4)
            }
            
            VStack{
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(buttonText)
                    .font(.tabBar)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    CustomTabBarButton(buttonText: "Chats", imageName: "bubble.left", isActive: true)
}
