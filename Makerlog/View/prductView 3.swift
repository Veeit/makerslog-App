//
//  prductView.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import SwiftUI
import URLImage

struct productView: View {
    @ObservedObject var data: productViewData
    var body: some View {
        VStack() {
            if self.data.products.count > 0 {
                ForEach(self.data.products) { product in
                    HStack() {
                        URLImage(URL(string: product.icon)!,
                                 processors: [ Resize(size: CGSize(width: 70, height: 70), scale: UIScreen.main.scale) ],
                                 content: {
                            $0.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                            .cornerRadius(20)
                        })
                            .frame(width: 70, height: 70)
                        
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .bold()
                            Text(product.productDescription ?? "")
                        }
                        Spacer()
                    }
                    .padding(10)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(10)
                }
            } else {
                Text("no product set 🤷🏻‍♂️")
                .padding(10)
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.primary.opacity(0.1))
                .cornerRadius(10)
            }
            
        }
    }
}
