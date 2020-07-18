//
//  UserTabView.swift
//  iOS
//
//  Created by Veit Progl on 16.07.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import SwiftUI

struct UserTabView: View {
    @EnvironmentObject var login: LoginData
    @EnvironmentObject var tabScreenData: TabScreenData
    @EnvironmentObject var user: UserData
    var userData: [User]?

    @State var showData = false
    
    var body: some View {
        NavigationView() {
            VStack() {
                if self.login.isLoggedIn == true {
                    UserView(userData: userData ?? self.login.userData)
                } else {
                    Text("You need to login to see your profile")

                    Button(action: {
                        if self.login.acceptedDatapolicy == false {
                            self.showData.toggle()
                        } else {
                            self.login.login()
                            self.login.getUser()
                        }
                    }) {
                        Text("Login").foregroundColor(Color.blue)
                    }
                }
            }
            .navigationBarTitle("User Profile", displayMode: .inline)
            .alert(isPresented: $showData, content: {datasecurityAlert()})
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func datasecurityAlert() -> Alert {
            let save = ActionSheet.Button.default(Text("Accept")) {
                self.login.acceptDatapolicy()
                self.login.login()
                self.tabScreenData.setOnbaording()
                self.tabScreenData.showOnboarding = false
            }

            // If the cancel label is omitted, the default "Cancel" text will be shown
            let cancel = ActionSheet.Button.cancel(Text("Open policy")) {
    //            self.tabScreenData.showDataPolicy.toggle()
                self.tabScreenData.presentSheet = .showDataPolicy
                self.tabScreenData.showSheet = true
            }

            return Alert(title: Text("Datasecurity is important"),
                         message: Text("""
        You need to read the datasecurity policy first.
        """),
                         primaryButton: save,
                         secondaryButton: cancel)
        }
}
