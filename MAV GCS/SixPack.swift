//
//  SixPack.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/9/25.
//

import SwiftUI

struct SixPack: View {
    @State var isBeating: Bool = false
    let telemetry: TelemetryFetcher
    @Binding var orientation: UIDeviceOrientation
    
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
    @State var pitch: Double = 0.0
    @State var roll: Double = 0.0
    @Binding var bruh: Int
    
    var body: some View {
        ZStack {
            
            if orientation == UIDeviceOrientation.landscapeLeft || orientation == UIDeviceOrientation.landscapeRight {
                HStack {
                    VStack {
                        CircleGauge(colorFunction: altitudeFunc, minVal: 0.0, maxVal: 400.0, unit: "FT", name: "ALTITUDE", bottomLabel: "AGL", value: $altitudeASL)
                            .frame(width: 225, height: 225)
                        Spacer()
                        SpeedCluster(verticalSpeed: $verticalSpeed, horizontalSpeed: $horizontalSpeed, airspeed: $airspeed)
                            .frame(width: 225, height: 225)
                        Spacer()
                        CircleGauge(colorFunction: throttleFunc, minVal: 0.0, maxVal: 100.0, unit: "%", name: "THROTTLE", bottomLabel: "", value: $throttle)
                            .frame(width: 225, height: 225)
                        
                    }
                    VStack {
                        AttitudeIndicator(pitch: $pitch, roll: $roll)
                            .frame(width: 225, height: 225)
                        Spacer()
                        Heartbeat(isBeating: $isBeating, hz: $heartbeatHZ)
                            .frame(width: 225, height: 225)
                        Spacer()
                        Compass(heading: $heading)
                            .frame(width: 225, height: 225)
                    }
                }
            } else {
                VStack {
                    HStack {
                        CircleGauge(colorFunction: altitudeFunc, minVal: 0.0, maxVal: 400.0, unit: "FT", name: "ALTITUDE", bottomLabel: "ASL", value: $altitudeASL)
                            .frame(width: 225, height: 225)
                        Spacer()
                        SpeedCluster(verticalSpeed: $verticalSpeed, horizontalSpeed: $horizontalSpeed, airspeed: $airspeed)
                            .frame(width: 225, height: 225)
                        Spacer()
                        CircleGauge(colorFunction: throttleFunc, minVal: 0.0, maxVal: 100.0, unit: "%", name: "THROTTLE", bottomLabel: "", value: $throttle)
                            .frame(width: 225, height: 225)
                    }
                    HStack {
                        AttitudeIndicator(pitch: $pitch, roll: $roll)
                            .frame(width: 225, height: 225)
                        Spacer()
                        Heartbeat(isBeating: $isBeating, hz: $heartbeatHZ)
                            .frame(width: 225, height: 225)
                        Spacer()
                        Compass(heading: $heading)
                            .frame(width: 225, height: 225)
                    }
                }
            }
        }.onChange(of: bruh) { oldValue, newValue in
            if self.telemetry.telemetry.heartbeatID > self.heartbeat_id_old {
                self.beatOnce()
                heartbeat_id_old = self.telemetry.telemetry.heartbeatID
            }
            msg_id = self.telemetry.telemetry.msg_id
            heading = self.telemetry.telemetry.heading
            verticalSpeed = self.telemetry.telemetry.verticalSpeed
            horizontalSpeed = self.telemetry.telemetry.horizontalSpeed
            airspeed = self.telemetry.telemetry.airspeed
            throttle = self.telemetry.telemetry.throttle
            altitudeASL = self.telemetry.telemetry.altitudeASL
            heartbeatHZ = self.telemetry.telemetry.heartbeatHZ
            pitch = -self.telemetry.telemetry.pitch
            roll = self.telemetry.telemetry.roll
        }
    }
    
    private func beatOnce() {
        isBeating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isBeating = false
        }
    }
}
