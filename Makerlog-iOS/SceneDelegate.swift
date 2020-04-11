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
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    // swiftlint:disable all
    var window: UIWindow?
	// Envoierment Objects
	let tabScreenData = TabScreenData()
	let makerlogApiData = MakerlogAPI()
	let loginData = LoginData()
	let commentViewData = CommentViewData()
	let userData = UserData()

    let center = UNUserNotificationCenter.current()

    // Get the managed object context from the shared persistent container.
    let context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!

    func show<V: View>(view: V) {
        self.window?.rootViewController = UIHostingController(rootView: view)
    }
    
    func showMain() {
        self.show(view: TabScreen()
                        .environment(\.managedObjectContext, context)
                        .environmentObject(tabScreenData)
                        .environmentObject(makerlogApiData)
                        .environmentObject(loginData)
                        .environmentObject(commentViewData)
                        .environmentObject(userData)
                    )
    }
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let contentView = TabScreen()
							.environment(\.managedObjectContext, context)
							.environmentObject(tabScreenData)
							.environmentObject(makerlogApiData)
							.environmentObject(loginData)
							.environmentObject(commentViewData)
							.environmentObject(userData)

        let onboarding = Onboarding()
                            .environment(\.managedObjectContext, context)
                            .environmentObject(tabScreenData)
                            .environmentObject(loginData)
                            .environmentObject(userData)
                            .environmentObject(self)
        
        let root: UIViewController
        if !UserDefaults.standard.bool(forKey: "Onboarding") {
            root = UIHostingController(rootView: onboarding)
        } else {
            root = UIHostingController(rootView: contentView)
        }
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = root
            self.window = window
            window.makeKeyAndVisible()
        }
        
        center.removeAllDeliveredNotifications()
        
        center.getNotificationSettings { (settings) in
          if settings.authorizationStatus != .authorized {
                self.registerNotification()
          } else {
              self.removeAllNotification()
          }
        }
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
                print(error)
            }
            if granted {
                self.registerNotification()
            } else {
                self.removeAllNotification()
            }
            // Enable or disable features based on the authorization.
        }
            
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
		print("scene")
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
		
//		setData()
//		makerlogApiData.stopSockets()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
		makerlogApiData.getLogs()
		makerlogApiData.getDissucions()
        getLoginData()
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
//		setData()
//		makerlogApiData.stopSockets()
	}
    
    func registerNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Log your daily tasks!"
        content.body = "keep on logging, don't lose your streak!"

        #if targetEnvironment(macCatalyst)
        #else
            let date = DateComponents(hour: 17, minute: 00)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: trigger)
            center.add(request)
        #endif
    }
    
    func removeAllNotification() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }

}
