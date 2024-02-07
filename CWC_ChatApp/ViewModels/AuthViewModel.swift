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
    static func getLoggedInUserPhone() ->String{
        return Auth.auth().currentUser?.phoneNumber ?? ""
    }
    static func logout(){
        try? Auth.auth().signOut()
    }
    static func sendPhoneNumber(phone: String, completion: @escaping (Error?) -> Void){
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
            if error == nil {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    static func verifyCode(code: String, completion: @escaping (Error?) -> Void){
        //get verif id from local storage
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        //send verif to fb
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: code
        )
        //sign in
        Auth.auth().signIn(with: credential){authResult,error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
}
