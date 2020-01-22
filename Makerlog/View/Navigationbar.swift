//
//  Navigationbar.swift
//  Makerlog
//
//  Created by Veit Progl on 22.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import SwiftUI

struct Navigationbar<Presenting, Board>: View where Presenting: View, Board: View {
//struct BulletinBoard<Presenting>: View where Presenting: View {
    let presenting: Presenting
    let boardItem: () -> Board

    
    var body: some View {
        ZStack() {
            Text("ww")
            
            presenting
        }
    }
    
}


extension View {
    func addNavigationBar<board: View>(@ViewBuilder Board: @escaping () -> board) -> some View {
        Navigationbar(presenting: self, boardItem: Board)
    }
}
