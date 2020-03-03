//
//  LinkPreview.swift
//  iOS
//
//  Created by Veit Progl on 18.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

import LinkPresentation

struct LinkRow: UIViewRepresentable {
    var previewURL: URL
	@Binding var redraw: Bool

    func makeUIView(context: Context) -> LPLinkView {
        let view = LPLinkView(url: previewURL)

        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: previewURL) { (metadata, error) in
            if let meta = metadata {
                DispatchQueue.main.async {
                    view.metadata = meta
                    view.sizeToFit()
                    self.redraw.toggle()
                }
            } else if error != nil {
                let meta = LPLinkMetadata()
                meta.title = "Custom title"
                view.metadata = meta
                view.sizeToFit()
                self.redraw.toggle()
            }
        }

        return view
    }

    func updateUIView(_ view: LPLinkView, context: Context) {
        // New instance for each update
    }
}

struct StringLink: Identifiable {
	var id = UUID()
	var string: String
	var url: URL?
}

class LinkData: ObservableObject {
	@Published var links = [StringLink]()
	init(text: String) {
		findLinks(input: text)
	}

	//swiftlint:disable force_try 
	func findLinks(input: String) {
		let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
		let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

		for match in matches {
			guard let range = Range(match.range, in: input) else { continue }
			let url = input[range]
			links.append(StringLink(string: String(url), url: URL(string: String(url))))
		}
	}
}

struct LinkPreview: View {
    @State var redrawPreview = false
	@State var links: LinkData

	var body: some View {
		//swiftlint:disable empty_parentheses_with_trailing_closure
		ForEach(links.links) { link in
			VStack() {
				if link.url != nil {
					LinkRow(previewURL: link.url!, redraw: self.$redrawPreview)
				}
			}
        }
        .environment(\.defaultMinListRowHeight, 200)
    }
}

struct LinkPreview_Previews: PreviewProvider {
    static var previews: some View {
		LinkPreview(links: LinkData(text: "This is a test with the URL https://www.hackingwithswift.com to be detected."))
    }
}
