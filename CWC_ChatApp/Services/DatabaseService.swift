//
//  DatabaseService.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 06/02/24.
//

import Foundation
import Contacts
import Firebase
import FirebaseStorage

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
    func setUserProfile(firstName: String, lastName: String, image : UIImage?, completion:  @escaping (Bool) -> Void){
        //TODO: guard agains logged out users
        //get reference to firestore
        let db = Firestore.firestore()
        //set profile
        //TODO: after auth
        let doc = db.collection("users").document()
        doc.setData(["firstname" : firstName, "lastname": lastName])
        //check if image is passed
        if let image = image{
            //create storage reference
            let storageRef = Storage.storage().reference()
            //from image to data
            let imageData = image.jpegData(compressionQuality: 0.8)
            //check if it was converted to data
            guard imageData != nil else{
                print("Couldnt convert")
                return
            }
            //specify pathname
            let path = "images/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(path)
            //upload image data
            let uploadTask = fileRef.putData(imageData!) { meta, error in
                if error == nil && meta != nil{
                    //set image to path
                    doc.setData(["photo" : path], merge: true){error in
                        if error == nil{
                            //success
                            completion(true)
                        }
                    }
                }else{
                    //upload wasnt successfull
                    completion(false)
                }
            }
            
            //set image path to profile
        }
    }
}
