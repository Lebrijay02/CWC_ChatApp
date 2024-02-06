//
//  OnBoardingButtonStyle.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import Foundation
import SwiftUI

struct OnBoardingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(Color.btnPrimary)
                .frame(height: 50)
            configuration.label
                .font(.button)
                .foregroundStyle(.txtButton)
        }
    }
}

