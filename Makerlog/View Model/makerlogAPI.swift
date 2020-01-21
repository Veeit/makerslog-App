//
//  makerlogAPI.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine
import OAuthSwift

class makerlogAPI: ObservableObject {
    @Published var logs = [Result]()

    func getResult() {
        print("start")
        let url = URL(string: "https://api.getmakerlog.com/tasks/?limit=200")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
               // data we are getting from network request
               let decoder = JSONDecoder()
               let response = try decoder.decode(Logs.self, from: data!)
                
                DispatchQueue.main.async {
                    self.logs = response.results
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func login() {
        // create an instance and retain it
        let oauthswift = OAuth2Swift(
            consumerKey:    "b8uO2fITOTsllzkIFsJ5S22RvsynSEn096ZnZteq",
            consumerSecret: "vop395nOpMQaKzh7BdkSBOZ8mgHClyUe1bUfDANPGLVMKoY97A3S6N9CWP2U4BPWXc5NBXHSOML2X68MDt6lChdQq3Rx4YeLqc0yQOta0DMwkLncURkGabpXQp9BjQlg",
            authorizeUrl:   "https://api.getmakerlog.com/oauth/authorize/",
            responseType:   "token"
        )
        
        let handle = oauthswift.authorize(
            withCallbackURL: URL(string: "makerlog-ios://oauth-callback/makerlog")!,
            scope: "tasks", state: "makerlog") { result in
            switch result {
            case .success(let (credential, response, parameters)):
              print(credential.oauthToken)
              // Do your request
            case .failure(let error):
              print(error.localizedDescription)
            }
        }
    }
    
    init() {
        getResult()
    }
}
