//
//  LoginData.swift
//  Makerlog
//
//  Created by Veit Progl on 22.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import CoreData
import OAuthSwift
import KeychainSwift

class LoginData: ObservableObject {

    let generator = UINotificationFeedbackGenerator()

    @Published var isSaved = false {
        didSet {
            if self.isSaved {
                let seconds = 1.0
                self.generator.notificationOccurred(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.isSaved = false
                    self.isOpen = false
                }
            }
        }
    }
    @Published var isOpen = false
    @Published var userToken = ""
    @Published var userSecret = ""
    @Published var meData = [Me]()

    init() {
        self.getMe()
    }

    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let keychain = KeychainSwift()
    private var responseData = [Login]()

    func checkLogin() {
        self.userToken = keychain.get("userToken") ?? ""
        self.userSecret = keychain.get("userSecret") ?? ""

        oauthswift.client.credential.oauthToken = self.userToken
        oauthswift.client.credential.oauthTokenSecret = self.userSecret
        print("user Token: \(self.userToken)")
    }

    func login() {
        oauthswift.allowMissingStateCheck = true
        oauthswift.authorize(
            withCallbackURL: URL(string: "makerlog.ios://oauth-callback/makerlog")!,
            scope: "", state: "") { result in
            switch result {
            case .success(let (credential, response, parameters)):
              print(credential.oauthToken)
              // Do your request
                print(response ?? "w")
                print(parameters)
                print(credential)
                self.userToken = credential.oauthToken
                self.userSecret = credential.consumerSecret
                self.keychain.set(self.userToken, forKey: "userToken")
                self.keychain.set(self.userSecret, forKey: "userSecret")
            case .failure(let error):
              print(error.localizedDescription)
                 print(result)
            }
        }
    }

    func getMe() {
        self.checkLogin()

        let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
        let requestURL = "https://api.getmakerlog.com/me/"

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(Me.self, from: response.data)

                    self.meData.append(data)
                    print(self.meData.first?.avatar ?? "no avatar")
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
                if case .tokenExpired = error {
                  print("old token")
               }
            }
        }
    }
}
