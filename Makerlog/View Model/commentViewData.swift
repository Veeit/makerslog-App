//
//  commentViewData.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine

class commentViewData: ObservableObject {
    @Published var comments = Comment()
    
    func getComments(logID: String) {
        let url = URL(string: "https://api.getmakerlog.com/tasks/\(logID)/comments/")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
               // data we are getting from network request
                let decoder = JSONDecoder()
                let response = try decoder.decode(Comment.self, from: data!)
                
                DispatchQueue.main.async {
                    self.comments = response
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    init(logID: String) {
        getComments(logID: logID)
    }
}
