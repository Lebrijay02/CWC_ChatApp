//
//  DatabaseService.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 06/02/24.
//

import Foundation
import Contacts
import Firebase

class DatabaseService{
    func getPlatformUsers(localContacts : [CNContact], completion:  @escaping ([User]) -> Void){
        //storing fetched users
        var platformUsers = [User]()
        //construct array of string p numbers
        var lookUpPhoneNumbers = localContacts.map { contact in
            //turn contact into phoneNumber
            return TextHelper.clean(phone: contact.phoneNumbers.first?.value.stringValue ?? "")
        }
        //make sure there are lokoked up numbers
        guard lookUpPhoneNumbers.count > 0 else{
            completion(platformUsers)
            return
        }
        //conect to db
        let db = Firestore.firestore()
        //perform loop for each 10 numbers
        while !lookUpPhoneNumbers.isEmpty{
            //get first 10 numbers
            let tenNumbers = Array(lookUpPhoneNumbers.prefix(10))
            //remove the 10
            lookUpPhoneNumbers = Array(lookUpPhoneNumbers.dropFirst(10))
            //query database
            let query = db.collection("users").whereField("phone", in: tenNumbers)
            //retrieve users from platform
            query.getDocuments { snapshot, error in
                //check error
                if error == nil && snapshot != nil{
                    //for each doc, create user
                    for doc in snapshot!.documents{
                        if let user = try? doc.data(as: User.self){
                            //append sto platform
                            platformUsers.append(user)
                        }
                    }
                    if lookUpPhoneNumbers.isEmpty{
                        //return users
                        completion(platformUsers)
                    }
                }
            }
        }
        
        
        
        //retrieve users in platform
        //return users
        completion(platformUsers)
    }
}
