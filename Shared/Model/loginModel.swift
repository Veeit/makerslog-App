//
//  loginModel.swift
//  Makerlog
//
//  Created by Veit Progl on 22.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import CoreData
import Combine

extension Login: Identifiable {}

extension Login {
    static func getAllItems() -> NSFetchRequest<Login> {
        let request: NSFetchRequest<Login> = Login.fetchRequest()
//        request.predicate = NSPredicate(format: "parent_project = nil")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        return request
    }
}
