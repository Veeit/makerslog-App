//
//  loginView.swift
//  Makerlog
//
//  Created by Veit Progl on 22.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import SwiftUI

struct loginView: View {
    @ObservedObject var data: loginData
    
    var body: some View {
        VStack() {
            HStack(alignment: .top) {
                Text("Login")
                    .font(Font.headline)
                Spacer()
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(Color("lightBackground"))
                    .onTapGesture {
                        self.data.isOpen = false
                        UIApplication.shared.windows.first?.endEditing(true)
                    }
            }.padding([.top], 20)
            
            VStack(alignment: .leading) {
                Text("user name")
                TextField("user name", text: self.$data.userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.bottom], 10)
                    .foregroundColor(self.data.hasError ? Color.red : Color.black)
                
                Text("password")
                SecureField("password", text: self.$data.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.bottom], 10)
                    .foregroundColor(self.data.hasError ? Color.red : Color.black)
            }
            
            HStack() {
                if data.isSaved {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .foregroundColor(Color.green)
                        .frame(width: 30, height: 30)
                } else {
                    Text("Done")
                        .font(Font.system(size: 18))
                        .bold()
                }
            }
            .padding(4)
            .padding([.leading, .trailing], 10)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
            .addBorder(self.data.hasError ? Color.red : Color.blue, width: 2, cornerRadius: 13)
            .foregroundColor(.blue)
            .onTapGesture {
                self.data.checkLogin()
            }
        }.padding()
    }
}
