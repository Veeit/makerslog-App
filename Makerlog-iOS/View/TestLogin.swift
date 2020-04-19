//
//  TestLogin.swift
//  iOS
//
//  Created by Veit Progl on 13.04.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct LoginTry: Identifiable{
    var id = UUID.init()
    var token = ""
    var refreshToken = ""
    var clientSecret = ""
    var secess = true
}

class Logins: ObservableObject {
    @Published var liste = [LoginTry]()
    
    func test() {
        print(oauthswift.client.credential.oauthVerifier)
        let token = oauthswift.client.credential.oauthToken
        print("user token \(token)")
        let parameters = ["token": token]
        let requestURL = "https://api.getmakerlog.com/me/"

        print("getME")

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters, onTokenRenewal: {
            (credential) in
//            self.liste.append(LoginTry(
//                token: oauthswift.client.credential.oauthToken,
//                refreshToken: oauthswift.client.credential.oauthRefreshToken,
//                clientSecret: oauthswift.client.credential.oauthTokenSecret))
            do {
                let newCredential = try credential.get()
                oauthswift.client.credential.oauthToken = newCredential.oauthToken
                print("=========== New Token: ===========")
                print(newCredential.oauthToken)
                print(oauthswift.client.credential.oauthToken)
                print("=========== New Token End ===========")
                setData()
            } catch {
                print("error")
            }
        }) { result in
            switch result {
            case .success(let response):
                print("worked")
                print("user token \(oauthswift.client.credential.oauthToken)")
                
                self.liste.append(LoginTry(
                        token: oauthswift.client.credential.oauthToken,
                        refreshToken: oauthswift.client.credential.oauthRefreshToken,
                        clientSecret: oauthswift.client.credential.oauthTokenSecret))
            case .failure(let error):
                print(error)
                if case .tokenExpired = error {
                  print("old token")
               }
                print(".failure")
                self.liste.append(LoginTry(
                token: oauthswift.client.credential.oauthToken,
                refreshToken: oauthswift.client.credential.oauthRefreshToken,
                clientSecret: oauthswift.client.credential.oauthTokenSecret,
                secess: false))
            }
        }
    }
}

struct TestLogin: View {
    @EnvironmentObject var tabScreenData: TabScreenData
    @EnvironmentObject var data: MakerlogAPI
    @EnvironmentObject var login: LoginData
    
    @ObservedObject var logins = Logins()
    @State var showData = false
    let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"

    var body: some View {
        NavigationView() {
            List(logins.liste) { login in
                VStack(alignment: .leading) {
                    Text("Token:")
                    Text(login.token)
                    Text("---")
                    Text("Refresh:")
                    Text(login.refreshToken)
                    Text("---")
                    Text("client: ")
                    Text(login.clientSecret)
                }.foregroundColor(login.secess ? Color.green : Color.red)
                   }
                   .alert(isPresented: $showData, content: {datasecurityAlert()})
                   .navigationBarTitle("LogBot", displayMode: .large)
                   .navigationBarItems(leading:
                            HStack() {
                                Button(action: {
                                    self.logins.liste.removeAll()
                                }) {
                                    Image(systemName: "trash").imageScale(.large)
                                }
                                Button(action: {
                                    self.tabScreenData.showSettings = true
                                }) {
                                   Image(systemName: "gear").imageScale(.large)
                                }
                            },
                           trailing:
                               HStack() {
                                   Button(action: {
                                        oauthswift.client.credential.oauthTokenExpiresAt = Date()
                                       self.logins.test()
                                   }) {
                                       Image(systemName: "arrow.2.circlepath")
                                   }.padding([.trailing], 8)

                                   if self.login.isLoggedIn == true {
                                       WebImage(url: URL(string: self.login.userData.first?.avatar ?? self.defaultAvartar),
                                            options: [.decodeFirstFrameOnly],
                                            context: [.imageThumbnailPixelSize : CGSize(width: 80, height: 80)])
                                       .placeholder(Image("imagePlaceholder"))
                                       .resizable()
                                       .aspectRatio(contentMode: .fit)
                                       .frame(width: 40, height: 40)
                                       .clipped()
                                       .cornerRadius(20)
                                       .onTapGesture {
                                           self.tabScreenData.userSheet = true
                                       }
                                   } else {
                                       Button(action: {
                                           if self.login.acceptedDatapolicy == false {
                                               self.showData.toggle()
                                           } else {
                                               self.login.login()
                                               self.login.getUser()
                                               self.logins.liste.append(LoginTry(
                                                   token: oauthswift.client.credential.oauthToken,
                                                   refreshToken: oauthswift.client.credential.oauthRefreshToken,
                                                   clientSecret: oauthswift.client.credential.oauthTokenSecret))
                                           }
                                       }) {
                                           Text("Login").foregroundColor(Color.blue)
                                       }
                                   }
                               }
                           )
                .onAppear(perform: {
                    self.logins.liste.append(LoginTry(
                    token: oauthswift.client.credential.oauthToken,
                    refreshToken: oauthswift.client.credential.oauthRefreshToken,
                    clientSecret: oauthswift.client.credential.oauthTokenSecret))


//                    self.login.getUser()
//                    self.logins.liste.append(LoginTry(
//                    token: oauthswift.client.credential.oauthToken,
//                    refreshToken: oauthswift.client.credential.oauthRefreshToken,
//                    clientSecret: oauthswift.client.credential.oauthTokenSecret))
                })
                .sheet(isPresented: self.$tabScreenData.showSettings, content: {
                    SettingsView(data: self.tabScreenData, loginData: self.login)
                })
        }
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
            self.tabScreenData.showDataPolicy.toggle()
        }

        return Alert(title: Text("Datasecurity is important"),
                     message: Text("""
    You need to read the datasecurity policy first.
    """),
                     primaryButton: save,
                     secondaryButton: cancel)
    }
}

struct TestLogin_Previews: PreviewProvider {
    static var previews: some View {
        TestLogin()
    }
}
