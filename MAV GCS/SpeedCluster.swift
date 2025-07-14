//
//  SpeedCluster.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/7/25.
//

import SwiftUI

struct SpeedCluster: View {
    @Binding var verticalSpeed: Double
    @Binding var horizontalSpeed: Double
    @Binding var airspeed: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 25, height: 25))
                .fill(Color("gaugeBack"))
            VStack {
                HStack {
                    Spacer()
                    CurveGauge(low_color: Color.gray, high_color: Color.green, min_value: -8, max_value: 8, units: "mph", name: "VERTICAL", image: "arrow.up.and.down", value: $verticalSpeed)
                        .frame(width: 200.0, height: 120.0)
                        .scaleEffect(0.5)
                        .frame(width: 95.0, height: 40.0)
                        
                    CurveGauge(low_color: Color.gray, high_color: Color.green, min_value: 0, max_value: 25, units: "mph", name: "HORIZONTAL", image: "arrow.left.and.right", value: $horizontalSpeed)
                        .frame(width: 200.0, height: 120.0)
                        .scaleEffect(0.5)
                        .frame(width: 95.0, height: 40.0)
                    
                    Spacer()
                }.frame(width:200)
                CurveGauge(low_color: Color.gray, high_color: Color.green, min_value: 0, max_value: 25, units: "mph", name: "AIRSPEED", image: "", value: $airspeed)
                    .frame(width: 200, height: 120)
            }.frame(width: 200, height: 200)
        }
        .frame(width: 225, height: 225)
    }
}
