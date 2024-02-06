//
//  AuthViewModel.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 05/02/24.
//

import Foundation
import FirebaseAuth

class AuthViewModel{
    static func isUserLoggedIn() ->Bool{
        return Auth.auth().currentUser != nil
    }
    static func getLoggedInUserId() ->String{
        return Auth.auth().currentUser?.uid ?? ""
    }
    static func logout(){
        try? Auth.auth().signOut()
    }
}
