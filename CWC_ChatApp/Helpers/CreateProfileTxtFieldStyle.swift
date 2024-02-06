//
//  CreateProfileTxtFieldStyle.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import Foundation
import SwiftUI

struct CreateProfileTxtFieldStyle: TextFieldStyle{
    func _body(configuration: TextField<Self._Label>) -> some View{
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 46)
                .foregroundStyle(.inputField)
            configuration
                .font(.tabBar)
                .padding()
        }
    }
}
