//
//  UserStatsView.swift
//  iOS
//
//  Created by Veit Progl on 29.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct UserStatsView: View {
	@State var input: [Float]
    var body: some View {
		VStack() {
			BarChartView(data: ChartData(points: input), title: "Title")
		}
    }
}

