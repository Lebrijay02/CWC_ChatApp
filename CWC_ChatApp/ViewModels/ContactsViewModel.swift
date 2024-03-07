//
//  ContactsViewModel.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 06/02/24.
//

import Foundation
import Contacts

class ContactsViewModel: ObservableObject{
    private var users = [User]()
    private var filteredText = ""
    @Published var filteredUsers = [User]()
    private var localContacts = [CNContact]()
    /*
     init(){
         print("getting contacts...")
         getLocalContacts()
     }
     */
    
    func getLocalContacts(){
        //perform so it doesnt block ui
        DispatchQueue.init(label: "getcontacts").async {
            if self.users.count <= 0{
                do{
                    print("doing")
                    //ask permision
                    let store = CNContactStore()
                    //list of keys to get
                    let keys = [CNContactPhoneNumbersKey, CNContactGivenNameKey, CNContactFamilyNameKey] as! [CNKeyDescriptor]
                    //create fetch request
                    let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
                    //get contacts frome phone
                    try store.enumerateContacts(with: fetchRequest) { contact, success in
                        //do something with contact
                        self.localContacts.append(contact)
                    }
                    DatabaseService().getPlatformUsers(localContacts: self.localContacts) { platformUser in
                        //set users to be published
                        DispatchQueue.main.async {
                            self.users = platformUser
                            //set filter
                            self.filterContacts(filterBy: self.filteredText)
                        }
                    }
                }catch{
                    //
                }
            }
        }
    }
    
    func filterContacts(filterBy: String){
        self.filteredText = filterBy
        if filteredText.isEmpty{
            self.filteredUsers = users
            return
        }
        self.filteredUsers = users.filter({ user in
            //criteria
            user.firstname?.lowercased().contains(filteredText) ?? false || user.lastname?.lowercased().contains(filteredText) ?? false || user.phone?.contains(filteredText) ?? false
        })
    }
    
    func getParticipants(ids: [String]) -> [User]{
        //filter out the users list for only the participants based on ids passed in
        let foundUsers = users.filter{ user in
            if user.id == nil{
                return false
            }else{
                return ids.contains(user.id!)
            }
        }
        return foundUsers
    }
}
/*
 (lldb) po contact
 <CNContact: 0x107710c20: identifier=177C371E-701D-42F8-A03B-C61CA31627F6, givenName=Kate, familyName=Bell, organizationName=(not fetched), phoneNumbers=(
     "<CNLabeledValue: 0x6000017765c0: identifier=EF48385D-28C2-48DE-AAB3-A81BC5F16981, label=_$!<Mobile>!$_, value=<CNPhoneNumber: 0x600000c8b2a0: stringValue=(555) 564-8583, initialCountryCode=(nil)>, iOSLegacyIdentifier=0>",
     "<CNLabeledValue: 0x600001776640: identifier=3CD5F927-B150-4104-918B-C26DD6AC811B, label=_$!<Main>!$_, value=<CNPhoneNumber: 0x600000c8b6c0: stringValue=(415) 555-3695, initialCountryCode=(nil)>, iOSLegacyIdentifier=1>"
 ), emailAddresses=(not fetched), postalAddresses=(not fetched)>
 */
