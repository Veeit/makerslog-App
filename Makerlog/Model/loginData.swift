//
//  loginData.swift
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

class loginData: ObservableObject {
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
    @Published var userName = ""
    @Published var password = ""
    @Published var userToken = ""
    @Published var hasError = false {
        didSet {
            if self.hasError {
                let seconds = 2.0
                self.generator.notificationOccurred(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.hasError = false
                }
            }
        }
    }
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var responseData = [Login]()
    
    func checkLogin() {
        let response = FetchedObjectsViewModel(fetchedResultsController: NSFetchedResultsController(fetchRequest: Login.getAllItems(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil))
        self.responseData = response.fetchedObjects
        self.login()
        print(response.fetchedObjects)
    }
    
    func saveToken() {
        if responseData.count > 0 {
            self.responseData.first?.token = userToken
        } else {
            let newLogin = Login(context: self.managedObjectContext)
            newLogin.id = UUID().uuidString
            newLogin.token = userToken
        }
        
        do {
            try self.managedObjectContext.save()
            isSaved = true
            UIApplication.shared.windows.first?.endEditing(true)
        } catch {
            print(error)
        }
    }
    
    
    func saveLogin() {
        // create an instance and retain it
        let oauthswift = OAuth2Swift(
            consumerKey:    "",
            consumerSecret: "",
            authorizeUrl:   "https://api.getmakerlog.com/oauth/authorize/?client_id=UQ11ii4wKHaDU8WtI4zzZEVUM9BhGY3yYaBUacMp",
            responseType:   "token"
        )
        let handle = oauthswift.authorize(
            withCallbackURL: URL(string: "makerlog.ios://oauth-callback/makerlog")!,
            scope: "", state:"") { result in
            switch result {
            case .success(let (credential, response, parameters)):
              print(credential.oauthToken)
              // Do your request
            case .failure(let error):
              print(error.localizedDescription)
            }
        }
    }
    
    func login() {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "username",
            "value": self.userName,
            "type": "text"
          ],
          [
            "key": "password",
            "value": self.password,
            "type": "text"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""

        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
                do {
                    let paramSrc = param["src"] as! String
                    let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                      + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                } catch {
                    print(error)
                }
              
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.getmakerlog.com/api-token-auth/")!,timeoutInterval: Double.infinity)
        request.addValue("Basic dmVpdHBybzpOZTEzbGxpZQ==", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=--------------------------827106960304310950985789", forHTTPHeaderField: "Content-Type")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }

            DispatchQueue.main.async {
                let returnData = String(data: data, encoding: .utf8)!.split(separator: ":")
               // handel token
               print(returnData)
                
                if returnData.first == "{\"token\"" {
                    self.userToken = returnData[1].trimmingCharacters(in: CharacterSet(charactersIn: "}")).trimmingCharacters(in: CharacterSet(charactersIn: "\"")).trimmingCharacters(in: CharacterSet(charactersIn: " ")).trimmingCharacters(in: CharacterSet(charactersIn: "{"))
                    self.saveToken()
                } else {
                    self.hasError = true
                }
                
            }
            
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
}
