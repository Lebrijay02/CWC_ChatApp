//
//  ContactsListView.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 06/02/24.
//

import SwiftUI

struct ContactsListView: View {
    @EnvironmentObject var contactsViewModel : ContactsViewModel
    @State var filterText = ""
    var body: some View {
        VStack{
            //heading
            HStack{
                Text("Contactas")
                    .font(.pageTitle)
                Spacer()
                Button(action: {
                    //
                }, label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .tint(.iconSecondary)
                })
            }
            .padding(.top, 20)
            //searchbar
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.white)
                TextField("", text: $filterText)
                    .font(.tabBar)
                    .foregroundStyle(.txtInput)
                    .padding()
                    .placeholder(when: filterText.isEmpty) {
                        Text("Search for contact or number")
                            .foregroundColor(.txtInput)
                            .font(.bodyTxt)
                            .padding()
                    }
                
            }
            .frame(height: 46)
            //list
            if contactsViewModel.users.count > 0 {
                List (contactsViewModel.users){user in
                    //
                }
                .listStyle(.plain)
            }else{
                Spacer()
                Image("noContacts")
                Text("Hmm... Zero Contacts?")
                    .font(.titleTxt)
                    .padding(.top, 32)
                Text("Try saving some contacts on your phone!")
                    .font(.bodyTxt)
                    .padding(.top, 8)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContactsListView()
}
