//
//  Chat.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 18/02/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Chat: Codable, Identifiable{
    @DocumentID var id : String?
    var lastmsg : String?
    var numparticipants : Int
    var participantids : [String]
    @ServerTimestamp var updated : Date?
    var msgs : [ChatMessasge]?
}

struct ChatMessasge: Codable, Identifiable, Hashable{
    @DocumentID var id : String?
    var imgurl : String?
    var msg : String?
    var senderid : String
    @ServerTimestamp var timestamp : Date?
    
}

