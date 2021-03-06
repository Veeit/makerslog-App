//
//  AppDelegate.swift
//  Makerlog
//
//  Created by Veit Progl on 20.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import UIKit
import CoreData
import OAuthSwift
import KeychainAccess

// swiftlint:disable line_length

var oauthswift = OAuth2Swift(
	consumerKey: "b8uO2fITOTsllzkIFsJ5S22RvsynSEn096ZnZteq",
	consumerSecret: "vop395nOpMQaKzh7BdkSBOZ8mgHClyUe1bUfDANPGLVMKoY97A3S6N9CWP2U4BPWXc5NBXHSOML2X68MDt6lChdQq3Rx4YeLqc0yQOta0DMwkLncURkGabpXQp9BjQlg",
	authorizeUrl: "https://api.getmakerlog.com/oauth/authorize/",
	accessTokenUrl: "https://api.getmakerlog.com/oauth/token/",
	responseType: "code"
)
var defaults = UserDefaults.standard
let keychain = Keychain(service: "dev.veit.logbot" , accessGroup: "7RPD69GC7T.veit.dev.logbot").synchronizable(true)

func setData() {
//    keychain["userToken"] = oauthswift.client.credential.oauthToken
//    keychain["userSecret"] = oauthswift.client.credential.oauthTokenSecret
//    keychain["userRefreshToken"] = oauthswift.client.credential.oauthRefreshToken
    print("UPDATE    _______--------____-----____")
    do {
        try keychain
            .synchronizable(true)
            .set(oauthswift.client.credential.oauthToken, key: "userToken")
        try keychain
            .synchronizable(true)
            .set(oauthswift.client.credential.oauthTokenSecret, key: "userSecret")
        try keychain
            .synchronizable(true)
            .set(oauthswift.client.credential.oauthRefreshToken, key: "userRefreshToken")
    } catch let error {
        print("error: \(error)")
    }
}

func getLoginData() {
    oauthswift.client.credential.oauthToken = keychain["userToken"] ?? ""
    oauthswift.client.credential.oauthTokenSecret = keychain["userSecret"] ?? ""
    oauthswift.client.credential.oauthRefreshToken = keychain["userRefreshToken"] ?? ""
    
    print(oauthswift.client.credential.oauthRefreshToken)
}

func newToken() {
    print(oauthswift.client.credential.oauthVerifier)
    let token = oauthswift.client.credential.oauthToken
    print("user token \(token)")
    let parameters = ["token": token]
    let requestURL = "https://api.getmakerlog.com/me/"

    print("getME")

    oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters, onTokenRenewal: {
        (credential) in
        do {
            let newCredential = try credential.get()
            oauthswift.client.credential.oauthToken = newCredential.oauthToken
            print("=========== New Token: ===========")
            print(newCredential.oauthToken)
            print(oauthswift.client.credential.oauthToken)
            print("=========== New Token End ===========")
            setData()
        } catch {
            print("error")
        }
    }) { result in
        switch result {
        case .success(_):
            print("worked")
            print("user token \(oauthswift.client.credential.oauthToken)")
        case .failure(let error):
            print(error)
            if case .tokenExpired = error {
              print("old token")
           }
            print(".failure")
        }
    }
}

// swiftlint:enable line_length

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    // swiftlint:disable all
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        // Get Login Data
        getLoginData()
        oauthswift.client.credential.oauthTokenExpiresAt = Date()

        if oauthswift.client.credential.oauthToken != "" {
            defaults.set(true, forKey: "isLogedIn")
//            newToken()
        } else {
            defaults.set(false, forKey: "isLogedIn")
        }
		
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Makerlog")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
