//
//  DownView.swift
//  iOS
//
//  Created by Veit Progl on 19.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import UIKit
import Down

struct TextWithAttributedString: UIViewRepresentable {

    var attributedString: NSAttributedString

    func makeUIView(context: Context) -> ViewWithLabel {
        let view = ViewWithLabel(frame: .zero)
        return view
    }

    func updateUIView(_ uiView: ViewWithLabel, context: Context) {
        uiView.setString(attributedString)
    }
}

class ViewWithLabel : UIView {
    private var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame:frame)
        self.addSubview(label)
        label.numberOfLines = 0
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setString(_ attributedString:NSAttributedString) {
        self.label.attributedText = attributedString
    }

    override var intrinsicContentSize: CGSize {
        label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 50, height: 9999))
    }
}

import WebKit

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct WebView : UIViewRepresentable {
    let request: URLRequest
      
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
      
}  
