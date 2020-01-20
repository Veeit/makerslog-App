//
//  ContentView.swift
//  Makerlog
//
//  Created by Veit Progl on 20.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import Foundation
import URLImage
import SwiftUIPullToRefresh

class makerlogAPI: ObservableObject {
    @Published var logs = [Result]()
    
    func getResult() {
        print("start")
        let url = URL(string: "https://api.getmakerlog.com/tasks/?limit=200")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
               // data we are getting from network request
               let decoder = JSONDecoder()
               let response = try decoder.decode(Logs.self, from: data!)
                
                DispatchQueue.main.async {
                    self.logs = response.results
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    init() {
        getResult()
    }
}

struct ContentView: View {
    @ObservedObject var data = makerlogAPI()
    
    var body: some View {
        
        RefreshableNavigationView(title: "Logs", action:{
            self.data.getResult()
        }){
            ForEach(self.data.logs){ log in
                VStack(alignment: .leading) {
                    HStack() {
                        URLImage(URL(string: log.user.avatar)!,
                                 processors: [ Resize(size: CGSize(width: 40, height: 40), scale: UIScreen.main.scale) ],
                                 content: {
                            $0.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .cornerRadius(20)
                        })
                            .frame(width: 40, height: 40)
                        Text(log.user.username).font(.subheadline).bold()
                        Spacer()
                        Text("\(log.user.makerScore) 🏆")
                    }
                    Text(log.content)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
