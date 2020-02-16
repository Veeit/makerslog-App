//
//  LogViewData.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine

class LogViewData: ObservableObject {
    @Published var data: Result
	
	init(data: Result) {
        self.data = data
    }
}
