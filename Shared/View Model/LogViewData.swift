//
//  LogViewData.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine
import OAuthSwift
import SwiftUI

class LogViewData: ApiModel, ObservableObject {
    @Published var data: Log

	init(data: Log) {
        self.data = data
    }
    
    func updateLog(){
        let token = oauthswift.client.credential.oauthToken
        print(token)
        let parameters = ["token": token]

        let requestURL = "https://api.getmakerlog.com/tasks/\(data.id)/"
        print(requestURL)
        
        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters, onTokenRenewal: {
            (credential) in
                setData()
        }) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let newdata = try decoder.decode(Log.self, from: response.data)
                    
                    self.data = newdata

                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
                if case .tokenExpired = error {
                  print("old token")
               }
                DispatchQueue.main.async {
                    self.errorText = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }
}
