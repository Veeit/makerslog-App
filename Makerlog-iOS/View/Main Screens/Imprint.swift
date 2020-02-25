//
//  Imprint.swift
//  iOS
//
//  Created by Veit Progl on 25.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct Imprint: View {
    var body: some View {
		ScrollView() {
			VStack(alignment: .leading) {
				Text("""
					Responsible for the development of this app:
					Veit Progl

					Phone: +49 (0) 15678 / 522621

					mail@veit.dev

					Postal address:
					Veit Progl
					41564 Kaarst
					Maximilan-Kolbe-Str. 7

					Termes of Service and Privacy of Makerlog can be found at:
					""").multilineTextAlignment(.leading)
				Button(action: {
					self.openMakerlogAbout()
				}) {
					Text("https://getmakerlog.com/about")
				}
				Spacer()
			}.navigationBarTitle("Imprint")
				.padding([.leading, .trailing])
		}
    }
	
	func openMakerlogAbout() {
		if let url = URL(string: "https://getmakerlog.com/about") {
			UIApplication.shared.open(url)
		}
	}
}

struct Imprint_Previews: PreviewProvider {
    static var previews: some View {
        Imprint()
    }
}
