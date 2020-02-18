//
//  progressImg.swift
//  iOS
//
//  Created by Veit Progl on 18.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct ProgressImg: View {
	@State var done: Bool
	@State var inProgress: Bool

    var body: some View {
		HStack() {
			if done {
				Image(systemName: "checkmark.circle").padding([.top], 5)
			}
			if inProgress {
				Image(systemName: "circle").padding([.top], 5)
			}
		}
    }
}
