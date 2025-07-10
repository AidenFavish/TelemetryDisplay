//
//  SixPack.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/9/25.
//

import SwiftUI

struct SixPack: View {
    @State var isBeating: Bool = false
    let telemetry: TelemetryData
    
    @State var msg_id: Int = -1
    @State var heading: Double = -1.0
    @State var airspeed: Double = -1.0
    @State var verticalSpeed: Double = -1.0
    @State var horizontalSpeed: Double = -1.0
    @State var altitudeASL: Double = -1.0
    @State var heartbeatId: Int = -1
    @State var heartbeatHZ: Double = -1.0
    @State var throttle: Double = -1.0
    @State var heartbeat_id_old: Int = -1
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            if isLandscape {
                HStack {
                    VStack {
                        CircleGauge(colorFunction: altitudeFunc, minVal: 0.0, maxVal: 400.0, unit: "FT", name: "ALTITUDE", bottomLabel: "AGL", value: $altitudeASL)
                            .padding()
                        Spacer()
                        SpeedCluster(verticalSpeed: $verticalSpeed, horizontalSpeed: $horizontalSpeed, airspeed: $airspeed)
                            .padding()
                        Spacer()
                        CircleGauge(colorFunction: throttleFunc, minVal: 0.0, maxVal: 100.0, unit: "%", name: "THROTTLE", bottomLabel: "", value: $throttle)
                            .padding()
                        
                    }
                    VStack {
                        Circle()
                            .foregroundStyle(.gaugeBack)
                            .frame(width: 225, height: 225)
                            .padding()
                        Spacer()
                        Heartbeat(isBeating: $isBeating, hz: $heartbeatHZ)
                            .padding()
                        Spacer()
                        Compass(heading: $heading)
                            .padding()
                    }
                }
            } else {
                VStack {
                    HStack {
                        CircleGauge(colorFunction: altitudeFunc, minVal: 0.0, maxVal: 400.0, unit: "FT", name: "ALTITUDE", bottomLabel: "ASL", value: $altitudeASL)
                            .padding()
                        Spacer()
                        SpeedCluster(verticalSpeed: $verticalSpeed, horizontalSpeed: $horizontalSpeed, airspeed: $airspeed)
                            .padding()
                        Spacer()
                        CircleGauge(colorFunction: throttleFunc, minVal: 0.0, maxVal: 100.0, unit: "%", name: "THROTTLE", bottomLabel: "", value: $throttle)
                            .padding()
                    }
                    HStack {
                        Circle()
                            .foregroundStyle(.gaugeBack)
                            .frame(width: 225, height: 225)
                            .padding()
                        Spacer()
                        Heartbeat(isBeating: $isBeating, hz: $heartbeatHZ)
                            .padding()
                        Spacer()
                        Compass(heading: $heading)
                            .padding()
                    }
                }
            }
        }.onChange(of: self.telemetry) { oldValue, newValue in
            if self.telemetry.heartbeatID > self.heartbeat_id_old {
                self.beatOnce()
                heartbeat_id_old = self.telemetry.heartbeatID
            }
            msg_id = self.telemetry.msg_id
            heading = self.telemetry.heading
            verticalSpeed = self.telemetry.verticalSpeed
            horizontalSpeed = self.telemetry.horizontalSpeed
            airspeed = self.telemetry.airspeed
            throttle = self.telemetry.throttle
            altitudeASL = self.telemetry.altitudeASL
            heartbeatHZ = self.telemetry.heartbeatHZ
        }
    }
    
    private func beatOnce() {
        isBeating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isBeating = false
        }
    }
}
