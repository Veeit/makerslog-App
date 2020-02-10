//
//  TabScreen.swift
//  Makerlog
//
//  Created by Veit Progl on 27.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

class TabScreenData: ObservableObject {
	@Published var userSheet = false

	@Published var showDetailView = false
}

struct TabScreen: View {
    @EnvironmentObject var data: TabScreenData
	@EnvironmentObject var login: LoginData
    // swiftlint:disable empty_parentheses_with_trailing_closure

    var body: some View {
		TabView {
			VStack {
				LogFeedView()
			}
			.tabItem({ TabLabel(imageName: "house.fill", label: "Home") })

            VStack {
				AddLogView()
			}
            .tabItem({ TabLabel(imageName: "plus.square.fill", label: "Add") })

			VStack {
				NotificationsView()
			}
            .tabItem({ TabLabel(imageName: "bell.fill", label: "Notification") })

			VStack {
				ExampleView()
			}
            .tabItem({ TabLabel(imageName: "bell.fill", label: "Notification") })

        }
		.sheet(isPresented: self.$data.userSheet, content: {UserView(login: self.login)})
    }

    struct TabLabel: View {
           let imageName: String
           let label: String

           var body: some View {
               HStack {
                   Image(systemName: imageName)
                   Text(label)
               }
           }
       }
}

struct TabScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabScreen()
    }
}


struct ExampleView: View {
    @State private var show: Bool = false
    
    var body: some View {
        
        Button("Open Sheet") {
            self.show = true
        }
        .padding(10).border(show ? Color.red : Color.clear)
        .actionSheet(isPresented: $show, content: aSheet)
        
    }
    
    func aSheet() -> ActionSheet {

        let send = ActionSheet.Button.default(Text("Send")) { print("hit send") }
        let draft = ActionSheet.Button.default(Text("Draft")) { print("hit draft") }

        // If the cancel label is omitted, the default "Cancel" text will be shown
        let cancel = ActionSheet.Button.cancel(Text("Abort")) { print("hit abort") }

        let buttons: [ActionSheet.Button] = [send, draft, cancel]
        
        return ActionSheet(title: Text("Title"),
                           message: Text("Message goes here"),
                           buttons: buttons)
    }

}
