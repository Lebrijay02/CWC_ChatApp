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
import FirebaseFirestore
import FirebaseCore

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
        completion(platformUsers)
    }
    
    func setUserProfile(firstName: String, lastName: String, image : UIImage?, completion:  @escaping (Bool) -> Void){
        //Ensure user is logged in
        guard AuthViewModel.isUserLoggedIn() != false else{
            print("user not logged in")
            return
        }
        //get reference to firestore
        let db = Firestore.firestore()
        //set profile
        //TODO: after auth
        let doc = db.collection("users").document(AuthViewModel.getLoggedInUserId())
        doc.setData(["firstname" : firstName, "lastname": lastName, "phone": TextHelper.clean(phone: AuthViewModel.getLoggedInUserPhone())])
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
            fileRef.putData(imageData!) { meta, error in
                if error == nil && meta != nil{
                    //get full url
                    fileRef.downloadURL { url, error in
                        if url != nil && error == nil{
                            //set image to path
                            doc.setData(["photo" : url!.absoluteString], merge: true){error in
                                if error == nil{
                                    //success
                                    completion(true)
                                }
                            }
                        }else{
                            completion(false)
                        }
                    }
                }else{
                    //upload wasnt successfull
                    completion(false)
                }
            }
            
            //set image path to profile
        }else{
            //no image set
            completion(true)
        }
        
    }
    
    func checkUserProfile(completion:  @escaping (Bool) -> Void){
        //check if logged in
        guard AuthViewModel.isUserLoggedIn() != false else{
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(AuthViewModel.getLoggedInUserId()).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching document: \(error)")
            } else if let snapshot = snapshot {
                if snapshot.exists {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        /*
         db.collection("users").document(AuthViewModel.getLoggedInUserId()).getDocument{ snapshot, error in
             //TODO: keep user profile data
             if snapshot != nil && error == nil{
                 completion(snapshot!.exists)

             }else{
                 completion(snapshot.false)
             }
         }
         */
    }
}
