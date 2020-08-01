//
//  TodayData.swift
//  iOS
//
//  Created by Veit Progl on 29.07.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import CoreData
import OAuthSwift


class TodayData: ApiModel, ObservableObject {
    @Published var user = [User]()
    @Published var name = "no user"
    @Published var archivments: Archivments?
    @Published var stats = [UserStats]()
    @Published var notification: Notification?
    @Published var todo = [Log]()

    enum NetworkError: Error {
        case url
        case server
        case timeout
    }

    func load(){
        DispatchQueue.global(qos: .utility).async {
            let result = self.getUser()
                .flatMap { _ in self.getTodayLogs() }
                .flatMap { _ in self.getNotifications() }
                .flatMap { _ in self.getArchivments() }
                .flatMap { _ in self.getUserStats() }
            
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    print(data)
                case let .failure(error):
                    print("error: \(error)")
                }
            }
        }
    }
    
    func getUser() -> Result<[User], NetworkError> {
        let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
        let requestURL = "https://api.getmakerlog.com/me/"
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<[User], NetworkError>!

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters, onTokenRenewal: {
            (credential) in
            setData()
        }) { data in
            switch data {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(User.self, from: response.data)

                     DispatchQueue.main.async {
                        self.user = [data]
                        result = .success([data])
                        semaphore.signal()
                     }
                } catch {
                    DispatchQueue.main.async {
                        print(response.data)
                        print(error)
                        result = .failure(.server)
                        semaphore.signal()
                    }
                }
            case .failure(let error):
                print(error)
                if case .tokenExpired = error {
                  print("old token")
               }
                DispatchQueue.main.async {
                    result = .failure(.server)
                    semaphore.signal()
                }
            }
        }
        
        if semaphore.wait(timeout: .now() + 15) == .timedOut {
            result = .failure(.timeout)
            semaphore.signal()
        }
        
        return result
    }
    
    func getUserName() {
        if self.user.first?.firstName != "" && self.user.first?.lastName != "" {
            self.name = "\(self.user.first?.firstName ?? "no") \(self.user.first?.lastName ?? "name")"
        } else {
            self.name = self.user.first?.username ?? "no username"
        }
    }
    
    func getArchivments() -> Result<Archivments, NetworkError> {
        let path = "https://api.getmakerlog.com/users/" + (self.user.first?.username ?? "") + "/achievements/"
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Archivments, NetworkError>!

        guard let url = URL(string: path) else {
            return .failure(.url)
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                let decoded = try! JSONDecoder().decode(Archivments.self, from: data)
                result = .success(decoded)
                DispatchQueue.main.async {
                    self.archivments = decoded
                }
            } else {
                result = .failure(.server)
            }
            semaphore.signal()
        }.resume()
        
        if semaphore.wait(timeout: .now() + 15) == .timedOut {
            result = .failure(.timeout)
        }
        
        return result
    }
    
    func getUserStats() -> Result<[UserStats], NetworkError> {
        let path = "https://api.getmakerlog.com/users/" + (self.user.first?.username ?? "") + "/stats/"
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<[UserStats], NetworkError>!

        guard let url = URL(string: path) else {
            return .failure(.url)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            if let data = data {
                let decoded = try! JSONDecoder().decode(UserStats.self, from: data)
                result = .success([decoded])
                DispatchQueue.main.async {
                    self.stats.removeAll()
                    self.stats.append(decoded)
                }
                
            } else {
                result = .failure(.server)
            }
            semaphore.signal()
        }.resume()
        
        if semaphore.wait(timeout: .now() + 15) == .timedOut {
            result = .failure(.timeout)
        }
        
        return result
    }
    
    func getNotifications() -> Result<Notification, NetworkError> {
        let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
        let requestURL = "https://api.getmakerlog.com/notifications/"
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Notification, NetworkError>!

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters, onTokenRenewal: {
            (credential) in
            setData()
            result = .failure(.timeout)
            semaphore.signal()
        }) { data in
            switch data {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(Notification.self, from: response.data)

                     DispatchQueue.main.async {
                        self.notification = data
                        result = .success(data)
                        semaphore.signal()
                     }
                } catch {
                    DispatchQueue.main.async {
                        print(response.data)
                        print(error)
                        result = .failure(.server)
                        semaphore.signal()
                    }
                }
            case .failure(let error):
                print(error)
                if case .tokenExpired = error {
                  print("old token")
               }
                DispatchQueue.main.async {
                    result = .failure(.server)
                    semaphore.signal()
                }
            }
        }
        
        if semaphore.wait(timeout: .now() + 15) == .timedOut {
            result = .failure(.timeout)
            semaphore.signal()
        }
        
        return result
    }
    
    func getTodayLogs() -> Result<[Log], NetworkError> {
        let path = "https://api.getmakerlog.com/tasks/?user=\(self.user.first?.id ?? 0)&done=false"
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<[Log], NetworkError>!

        guard let url = URL(string: path) else {
            return .failure(.url)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            if let data = data {
                let decoded = try! JSONDecoder().decode(Logs.self, from: data)
                result = .success(decoded.results)
                DispatchQueue.main.async {
                    self.todo =  decoded.results
                }
                
            } else {
                result = .failure(.server)
            }
            semaphore.signal()
        }.resume()
        
        if semaphore.wait(timeout: .now() + 15) == .timedOut {
            result = .failure(.timeout)
        }
        
        return result
    }
}
