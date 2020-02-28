//
//  SceneDelegate.swift
//  Makerlog
//
//  Created by Veit Progl on 20.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import UIKit
import SwiftUI
import OAuthSwift
import URLImage
import KeychainSwift

// swiftlint:disable line_length

var oauthswift = OAuth2Swift(
	consumerKey: "b8uO2fITOTsllzkIFsJ5S22RvsynSEn096ZnZteq",
	consumerSecret: "vop395nOpMQaKzh7BdkSBOZ8mgHClyUe1bUfDANPGLVMKoY97A3S6N9CWP2U4BPWXc5NBXHSOML2X68MDt6lChdQq3Rx4YeLqc0yQOta0DMwkLncURkGabpXQp9BjQlg",
	authorizeUrl: "https://api.getmakerlog.com/oauth/authorize/",
	accessTokenUrl: "https://api.getmakerlog.com/oauth/token/",
	responseType: "code"
)
let keychain = KeychainSwift()

// swiftlint:enable line_length

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // swiftlint:disable all
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Get the managed object context from the shared persistent container.
        let context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!

        // Envoierment Objects
        let tabScreenData = TabScreenData()
        let makerlogApiData = MakerlogAPI()
        let loginData = LoginData()
		let commentViewData = CommentViewData()

		URLImageService.shared.setDefaultExpiryTime(3600.0)
		
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let contentView = TabScreen()
							.environment(\.managedObjectContext, context)
							.environmentObject(tabScreenData)
							.environmentObject(makerlogApiData)
							.environmentObject(loginData)
							.environmentObject(commentViewData)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            guard let url = URLContexts.first?.url else {
                return
            }
            if url.host == "oauth-callback" {
                OAuthSwift.handle(url: url)
            } else {
                print(url)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded
        // (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()

		keychain.set(oauthswift.client.credential.oauthToken, forKey: "userToken")
		keychain.set(oauthswift.client.credential.oauthTokenSecret, forKey: "userSecret")
		keychain.set(oauthswift.client.credential.oauthRefreshToken, forKey: "userRefreshToken")
    }

}
