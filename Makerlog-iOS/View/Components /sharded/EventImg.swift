//
//  EventImg.swift
//  Makerlog
//
//  Created by Veit Progl on 04.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct EventImg: View {
	@State var event: String
	var body: some View {
		if event == "github" {
			return Image("github").resizable().scaledToFill().frame(width: 20, height: 20)
		} else if event == "gitlab" {
			return Image("gitlab").resizable().scaledToFill().frame(width: 20, height: 20)
		} else if event == "telegram" {
			return Image("telegram").resizable().scaledToFill().frame(width: 20, height: 20)
		}
		return Image("spacer").resizable().scaledToFill().frame(width: 1, height: 1)
	}
}
