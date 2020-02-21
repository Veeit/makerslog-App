//
//  MarkdownView.swift
//  iOS
//
//  Created by Veit Progl on 20.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

class MarkdownData: ObservableObject {
	@Published var headlines = [String]()
	var input: String = ""
	
	func findHeadlines() {
		
	}
}

struct MarkdownView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct MarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownView()
    }
}
