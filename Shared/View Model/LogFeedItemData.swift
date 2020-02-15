//
//  LogFeedItemData.swift
//  iOS
//
//  Created by Veit Progl on 09.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine

class LogFeedItemData: ObservableObject {
	@Published var log: Result

	init(log: Result) {
		self.log = log
	}
}
