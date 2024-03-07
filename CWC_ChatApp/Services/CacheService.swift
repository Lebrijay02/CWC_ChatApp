//
//  CacheService.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 26/02/24.
//

import Foundation
import SwiftUI

class ChacheService{
    //stores image component with url string as key
    private static var imageCache = [String : Image]()
    
    static func getImage(key: String) -> Image?{
        return imageCache[key]
    }
    static func setImage(image : Image, key: String) {
        return imageCache[key] = image
    }
}
