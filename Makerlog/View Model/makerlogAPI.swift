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
    
    init() {
        getResult()
    }
}
