//
//  NavigationbarView.swift
//  Makerlog
//
//  Created by Veit Progl on 22.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct NavigationbarView: View {
    var body: some View {
        VStack() {
            Spacer()
            HStack(spacing: 15) {
                Image(systemName: "arrow.left")
                    .resizable()
                    .clipped()
                    .frame(width: 25, height: 25, alignment: .center)
                    .padding(7)
                    .background(Color("lightBackground"))
                    .cornerRadius(5)
                Image(systemName: "person.circle")
                    .resizable()
                    .clipped()
                    .frame(width: 25, height: 25, alignment: .center)
                    .padding(7)
                    .background(Color("lightBackground"))
                    .cornerRadius(5)
                Image(systemName: "tag.fill")
                    .resizable()
                    .clipped()
                    .frame(width: 25, height: 25, alignment: .center)
                    .padding(7)
                    .background(Color("lightBackground"))
                    .cornerRadius(5)
            }.frame(minWidth: 0, maxWidth: .infinity)
            .padding(9)
            .background(Color("background"))
            .cornerRadius(7)
        }.padding()
    }
}

struct NavigationbarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationbarView()
    }
}
