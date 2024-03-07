//
//  DateHelper.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 20/02/24.
//

import Foundation

class DateHelper{
    //static means there is no need to create instance of date
    static func chatTimeStamp(date: Date?) -> String{
        guard date != nil else{
            return ""
        }
        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        return df.string(from: date!)
        
    }
}
