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
    
    var chatListViewListeners = [ListenerRegistration]()
    var conversationViewListeners = [ListenerRegistration]()
    
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
    
    //MARK: Chat Methods
    func getAllChats(completion:  @escaping ([Chat]) -> Void){
        //reference db
        let db = Firestore.firestore()
        //query to chats where user is participant
        let chatsQuerry = db.collection("chats").whereField("participantids", arrayContains: AuthViewModel.getLoggedInUserId())
        
        let listener = chatsQuerry.addSnapshotListener { snapshot, error in
            if snapshot != nil && error == nil{
                var chats = [Chat]()
                print("created chat array")
                //print(snapshot)
                //loop
                for doc in snapshot!.documents{
                    print("looping...")
                    //parse data into chat struct
                    let chat = try? doc.data(as: Chat.self)
                    //dd chat into array
                    if let chat = chat{
                        chats.append(chat)
                        print("appended!")
                    }
                }
                //return data
                completion(chats)
            }else{
                print("error in db retrieval")
            }
        }
        
        //keep track of listener to close
        chatListViewListeners.append(listener)
    }
    
    func getAllMessages(chat: Chat, completion:  @escaping ([ChatMessasge]) -> Void){
        //check id not nil
        guard chat.id != nil else{
            completion([ChatMessasge]())
            return
        }
        //db reference
        let db = Firestore.firestore()
        //querry
        let msgsQuerry = db.collection("chats")
            .document(chat.id!).collection("msgs")
            .order(by: "timestamp")
        //perform querry
        let listener = msgsQuerry.addSnapshotListener{ snapshot, error in
            if snapshot != nil && error == nil{
                //loop and create instances
                var messages = [ChatMessasge]()
                //loop
                for doc in snapshot!.documents{
                    //parse data into chat struct
                    let msg = try? doc.data(as: ChatMessasge.self)
                    //dd chat into array
                    if let msg = msg{
                        messages.append(msg)
                    }
                }
                //return data
                completion(messages)
            }else{
                print("error in db retrieval")
            }
        }
        
        //keep track of listener to close
        conversationViewListeners.append(listener)
    }
    
    func sendMessage(msg : String, chat : Chat){
        //check if valid chat
        guard chat.id != nil else{
            return
        }
        //reference database
        let db = Firestore.firestore()
        print("connecting")
        //add message
        db.collection("chats").document(chat.id!).collection("msgs").addDocument(data: ["imgurl" : "", "msg" : msg, "senderid" : AuthViewModel.getLoggedInUserId(), "timestamp" : Date()])
        //update doc
        db.collection("chats").document(chat.id!).setData(["updated" : Date(), "lastmsg": msg], merge: true)

        
    }
    func sendPhotoMessage(img: UIImage, chat: Chat){
        //check if valid chat
        guard chat.id != nil else{
            return
        }
        //create storage reference
        let storageRef = Storage.storage().reference()
        //from image to data
        let imageData = img.jpegData(compressionQuality: 0.8)
        //check if it was converted to data
        guard imageData != nil else{
            print("Couldnt convert")
            return
        }
        //specify pathname
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        //upload image
        fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil{
                fileRef.downloadURL { url, error in
                    if error == nil && url != nil{
                        //reference database
                        let db = Firestore.firestore()
                        print("connecting")
                        //add image
                        db.collection("chats").document(chat.id!).collection("msgs").addDocument(data: ["imgurl" : url!.absoluteString, "msg" : "", "senderid" : AuthViewModel.getLoggedInUserId(), "timestamp" : Date()])
                        //update doc
                        db.collection("chats").document(chat.id!).setData(["updated" : Date(), "lastmsg": "image"], merge: true)
                    }
                }
            }
        }
    }
    
    func createChat(chat : Chat, completion: @escaping (String)-> Void){
        //reference database
        let db = Firestore.firestore()
        //create document
        let doc = db.collection("chats").document()
        //set data for document
        try? doc.setData(from: chat, completion: { error in
            //comunicade doc id
            completion(doc.documentID)
        })
    }
    
    func detatchChatListViewListeners(){
        for l in chatListViewListeners{
            l.remove()
        }
    }
    func detatchConversationViewListeners(){
        for l in conversationViewListeners{
            l.remove()
        }
    }
}
//addSnapshotListener fethces data constantly
