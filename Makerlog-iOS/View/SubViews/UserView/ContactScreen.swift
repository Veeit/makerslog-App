//
//  ContactScreen.swift
//  iOS
//
//  Created by Veit Progl on 19.04.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct ContactScreen: View {
    var user: User
    
    var body: some View {
        NavigationView() {
            List() {
                
                if self.user.website != "" {
                    Button(action: {
                        self.openLink(link: "\(self.user.website ?? "")")
                    }) {
                        Text("\(user.telegramHandle ?? "")")
                    }
                }
                if self.user.twitterHandle != "" {
                    Button(action: {
                        self.openLink(link: "https://twitter.com/\(self.user.twitterHandle ?? "")/")
                    }) {
                        Text("Twitter: \(user.twitterHandle ?? "")")
                    }
                }
                if self.user.githubHandle != "" {
                    Button(action: {
                        self.openLink(link: "https://github.com/\(self.user.githubHandle ?? "")/")
                    }) {
                        Text("GitHub: \(user.githubHandle ?? "")")
                    }
                }
                if self.user.bmcHandle != "" {
                    Button(action: {
                        self.openLink(link: "https://buymeacoffee.com/\(self.user.bmcHandle ?? "")/")
                    }) {
                        Text("Buy me a coffe: \(user.bmcHandle ?? "")")
                    }
                }
                if self.user.shipstreamsHandle != "" {
                    Button(action: {
                        self.openLink(link: "https://twitch.tv/\(self.user.shipstreamsHandle ?? "")/")
                    }) {
                        Text("Twitch: \(user.shipstreamsHandle ?? "")")
                    }
                }
                if self.user.telegramHandle != "" {
                    Button(action: {
                        self.openLink(link: "https://t.me/\(self.user.telegramHandle ?? "")")
                    }) {
                        Text("Telegram: \(user.telegramHandle ?? "")")
                    }
                }
                if self.user.instagramHandle != "" {
                    Button(action: {
                        self.openLink(link: "https://www.instagram.com/\(self.user.instagramHandle ?? "")/")
                    }) {
                        Text("Instagram: \(user.instagramHandle ?? "")")
                    }
                }
                
            }.navigationBarTitle("Contact \(user.username)")
        }
    }
    func openLink(link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
}
