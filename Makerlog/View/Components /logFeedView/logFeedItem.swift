//
//  logFeedItem.swift
//  Makerlog
//
//  Created by Veit Progl on 01.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import URLImage

struct LogFeedItem: View {
    var log: Result

    var body: some View {
        NavigationLink(destination: LogView(log: LogViewData(data: log),
                       comments: CommentViewData(logID: String(log.id)))) {

            // swiftlint:disable empty_parentheses_with_trailing_closure
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

                HStack(alignment: .top) {
                    if log.done {
                        Image(systemName: "checkmark.circle").padding([.top], 5)
                    }
                    if log.inProgress {
                        Image(systemName: "circle").padding([.top], 5)
                    }
                    Text(log.event ?? "")

                    Text(log.content)
                        .padding([.bottom], 15)
                        .lineLimit(20)

                    if log.praise > 0 {
                        Spacer()
                        Text("\(log.praise) 👏")
                    }
                }

                if log.attachment != nil {
                    URLImage(URL(string: log.attachment!)!,
                             content: {
                        $0.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .cornerRadius(7)
                    })
                }
            }
        }
    }
}

//struct logFeedItem_Previews: PreviewProvider {
//    static var previews: some View {
//        logFeedItem()
//    }
//}
