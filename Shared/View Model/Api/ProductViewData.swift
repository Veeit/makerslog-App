//
//  ProductViewData.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine

class ProductViewData: ApiModel, ObservableObject {
    @Published var products = [Product]()

    func getRelatedProject(projectID: String) {
		let url = URL(string: "https://api.getmakerlog.com/projects/\(projectID)/related/")!
		print(url)

		let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token]

		oauthswift.startAuthorizedRequest(url, method: .GET, parameters: parameters) { result in
			switch result {
			case .success(let response):
				do {
					let decoder = JSONDecoder()
					let data = try decoder.decode(Project.self, from: response.data)

					self.products = data.products
				} catch {
					print(error.localizedDescription)
					DispatchQueue.main.async {
						self.errorText = error.localizedDescription
						self.showError = true
					}
				}
			case .failure(let error):
				print(error.localizedDescription)
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

    init(projectID: String) {
		super.init()
        self.getRelatedProject(projectID: projectID)
    }
}
