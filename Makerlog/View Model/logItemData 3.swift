//
//  logItemData.swift
//  Makerlog
//
//  Created by Veit Progl on 30.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation

class logItemData: ObservableObject {
    @Published var log: Project
    
    init (log: Project) {
        self.log = log
    }
}
