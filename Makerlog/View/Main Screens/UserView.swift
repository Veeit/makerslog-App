//
//  UserView.swift
//  Makerlog
//
//  Created by Veit Progl on 01.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var login: LoginData
    @Binding var user: [Me]

    var body: some View {
        // swiftlint:disable empty_parentheses_with_trailing_closure
        VStack() {
            Text("Hello, World!")

            Text(self.user.first?.firstName ?? "ww")
        }

    }
}

//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView()
//    }
//}
