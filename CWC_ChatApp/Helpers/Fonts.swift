//
//  Fonts.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import Foundation
import SwiftUI

extension Font{
    
    public static var body : Font{
        return Font.custom("LexendDeca-Regular", size: 14)
    }
    public static var button : Font{
        return Font.custom("LexendDeca-SemiBold", size: 14)
    }
    public static var caption : Font{
        return Font.custom("LexendDeca-Regular", size: 10)
    }
    public static var tabBar : Font{
        return Font.custom("LexendDeca-Regular", size: 12)
    }
    public static var settings : Font{
        return Font.custom("LexendDeca-Regular", size: 16)
    }
    public static var title : Font{
        return Font.custom("LexendDeca-Bold", size: 23)
    }
    public static var pageTitle : Font{
        return Font.custom("LexendDeca-SemiBold", size: 33)
    }
    public static var chatHeading : Font{
        return Font.custom("LexendDeca-SemiBold", size: 19)
    }
}
/*
init(){
    for family in UIFont.familyNames{
        for fontName in UIFont.fontNames(forFamilyName: family){
            print("--\(fontName)")
        }
    }
}
 LexendDeca-Regular
 LexendDeca-SemiBold
 LexendDeca-Bold
 */
