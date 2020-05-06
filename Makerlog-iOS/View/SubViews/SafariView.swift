//
//  SafariView.swift
//  iOS
//
//  Created by Veit Progl on 06.05.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController

    var url: String?

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: URL(string: url ?? "https://getmakerlog.com/log")!)
    }

    func updateUIViewController(_ safariViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView()
    }
}
