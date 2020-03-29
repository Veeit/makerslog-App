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
	private var cancellable: AnyCancellable?
	var stop = false
	enum HTTPError2: LocalizedError {
		case statusCode
	}

    func getRelatedProject(projectID: String) {
		let url = URL(string: "https://api.getmakerlog.com/projects/\(projectID)/related/")!
		print(url)

		self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
		.tryMap { output in
			guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
				throw HTTPError2.statusCode
			}
			return output.data
		}
		.decode(type: Project.self, decoder: JSONDecoder())
		.eraseToAnyPublisher()
		.sink(receiveCompletion: { completion in
			switch completion {
			case .finished:
				break
			case .failure(let error):
				if error.localizedDescription == "The request timed out." {
					print("time out")
				} else {
					DispatchQueue.main.async {
						self.errorText = error.localizedDescription
						self.showError = true
						print(error)
					}
				}
			}
		}, receiveValue: { result in
			DispatchQueue.main.async {
				if !self.stop {
					self.products = result.products
					print(result)
				}
			}
		})
    }

    init(projectID: String) {
		super.init()
        self.getRelatedProject(projectID: projectID)
    }
}
