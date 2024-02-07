//
//  User.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 06/02/24.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable{
    @DocumentID var id : String?
    var firstname : String?
    var lastname : String?
    var phone : String?
    var photo : String?
}
