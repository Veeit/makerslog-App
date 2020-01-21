//
//  productViewData.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine

class productViewData: ObservableObject {
    @Published var products = [Product]()

    func getRelatedProject(projectID: String) {
        let url = URL(string: "https://api.getmakerlog.com/projects/\(projectID)/related/")!
        print(url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
               // data we are getting from network request
               let decoder = JSONDecoder()
               let response = try decoder.decode(Project.self, from: data!)
                
                DispatchQueue.main.async {
                    self.products = response.products
                    print(self.products)
                    print("==")
                    print(self.products.first?.name ?? "ww2")
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    init(id: String) {
        self.getRelatedProject(projectID: id)
    }
}
