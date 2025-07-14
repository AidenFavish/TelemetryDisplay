//
//  BatteryMonitor.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/10/25.
//

import SwiftUI

struct BatteryMonitor: View {
    @Binding var telem: TelemetryData
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.gaugeBack))
            HStack {
                VStack {
                    ForEach(0...telem.voltages.count - 1, id: \.self) { index in
                        CellMonitor(cellPercent: $telem.voltages[index], name: String(index + 1))
                    }
                }.padding(.vertical)
                    .padding(.leading)
                Spacer()
                VStack(alignment: .leading) {
                    Text("Voltage: \(String(format: "%.2f", telem.voltage)) V")
                    Text("Current: \(String(format: "%.2f", telem.current)) A")
                    Text("Power: \(Int(telem.power)) W")
                    Text("SOC: \(Int(telem.soc))%")
                    Text("Time Left: \(telem.time_left)")
                    Text("WH Left: \(Int(telem.wh_left)) WH")
                }.padding(.trailing)
                    .padding(.trailing)
            }
            
        }.frame(width: 325, height: 175)
    }
}
