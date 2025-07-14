//
//  InfoHeader.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/13/25.
//

import SwiftUI

struct InfoHeader: View {
    @Binding var sats: Int
    @Binding var satType: String
    @Binding var mode: String
    @Binding var armed: Bool
    @Binding var estop: Bool
    @Binding var latitude: Double
    @Binding var longitude: Double
    
    var body: some View {
        HStack {
            Spacer()
            Text(mode)
                .bold()
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gaugeBack)
                )
            Spacer()
            Text(armed ? "ARMED" : "DISARMED")
                .bold()
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(armed ? .red : .green)
                        .opacity(0.75)
                )
            Spacer()
            Text(estop ? "ESTOP ON" : "ESTOP OFF")
                .bold()
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(estop ? .green : .red)
                        .opacity(0.75)
                )
            Spacer()
            Label("\(sats) SATS [\(satType)]", systemImage: "antenna.radiowaves.left.and.right")
                .bold()
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gaugeBack)
                )
            Spacer()
            VStack {
                Text("lat: \(latitude)")
                    .bold()
                Text("lon: \(longitude)")
                    .bold()
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gaugeBack)
            )
            Spacer()
            
        }
    }
}
