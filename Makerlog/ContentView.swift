//
//  ContentView.swift
//  Makerlog
//
//  Created by Veit Progl on 20.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import Foundation
/*
 {
   "count": 0,
   "next": "http://example.com",
   "previous": "http://example.com",
   "results": [
     {
       "id": 0,
       "event": "slack",
       "done": true,
       "in_progress": true,
       "content": "string",
       "created_at": "2020-01-20T12:51:46Z",
       "updated_at": "2020-01-20T12:51:46Z",
       "due_at": "2020-01-20T12:51:46Z",
       "done_at": "2020-01-20T12:51:46Z",
       "user": {
         "id": 0,
         "username": "string",
         "first_name": "string",
         "last_name": "string",
         "status": "string",
         "description": "string",
         "verified": true,
         "private": true,
         "avatar": "http://example.com",
         "streak": "string",
         "timezone": "string",
         "week_tda": "string",
         "twitter_handle": "string",
         "instagram_handle": "string",
         "product_hunt_handle": "string",
         "github_handle": "string",
         "telegram_handle": "string",
         "bmc_handle": "string",
         "header": "http://example.com",
         "is_staff": true,
         "donor": true,
         "shipstreams_handle": "string",
         "website": "http://example.com",
         "tester": true,
         "is_live": true,
         "digest": true,
         "gold": true,
         "accent": "string",
         "maker_score": "string",
         "dark_mode": true,
         "weekends_off": true,
         "hardcore_mode": true
       },
       "project_set": [
         {
           "id": 0,
           "name": "string",
           "private": true,
           "user": 0
         }
       ],
       "praise": "string",
       "attachment": "http://example.com",
       "comment_count": "string"
     }
   ]
 }
 */
//struct log {
//    let count: Int
//    let next: String
//    let previous: String
//
//    let results
//    "results": [
//}

class makerlogAPI {
    func getData() -> String {
        let url = URL(string: "https://api.getmakerlog.com/tasks/")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
           do {
               // data we are getting from network request
               let decoder = JSONDecoder()
               let response = try decoder.decode(Logs.self, from: data!)
               print(response.results[0].content) //Output - EMT
            } catch { print(error) }
        }
        task.resume()
        
        return "www"
    }
}

struct ContentView: View {
    let data = makerlogAPI().getData()
    
    var body: some View {
        List() {
            Text("ww")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
