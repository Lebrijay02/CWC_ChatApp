//
//  AppDelegate.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import Foundation
import UIKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate{
    
    func application(_ application: UIApplication, 
        didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey : Any]?) -> Bool{
        FirebaseApp.configure()
        return true
    }
}
