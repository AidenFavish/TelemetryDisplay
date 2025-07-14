//
//  Telemetry.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/7/25.
//

import Foundation
import Combine

struct TelemetryData: Codable, Equatable {
    let msg_id: Int
    
    let heading: Double
    
    let airspeed: Double
    let verticalSpeed: Double
    let horizontalSpeed: Double
    
    let altitudeASL: Double
    
    let heartbeatID: Int
    let heartbeatHZ: Double
    
    let throttle: Double
    
    var voltages: [Double]
    let voltage: Double
    let current: Double
    let power: Double
    let soc: Double
    let time_left: String
    let wh_left: Double
    
    let sats: Int
    let gps_fix: String
    
    let armed: Bool
    let estop: Bool
    
    let mode: String
    
    let msg: String
    
    let lat: Double
    let lon: Double
    
    let roll: Double
    let pitch: Double
}

class TelemetryFetcher: ObservableObject {
    @Published var telemetry: TelemetryData = TelemetryData(msg_id: 0, heading: 0, airspeed: 0, verticalSpeed: 0, horizontalSpeed: 0, altitudeASL: 0, heartbeatID: 0, heartbeatHZ: 0, throttle: 0, voltages: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], voltage: 0.0, current: 0.0, power: 0.0, soc: 0.0, time_left: "00:00", wh_left: 0.0, sats: 0, gps_fix: "UNKNOWN", armed: false, estop: false, mode: "UNKNOWN", msg: "", lat: 0.0, lon: 0.0, roll: 0.0, pitch: 0.0)
    
    private var timer: Timer?

    private let url = URL(string: "http://192.168.8.120:8000/telemetry")! // Replace with your FastAPI IP

    func startFetching(interval: TimeInterval = 1.0) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.fetchTelemetry()
        }
    }

    func stopFetching() {
        timer?.invalidate()
        timer = nil
    }

    func fetchTelemetry() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("data couldn't load fromt GET telem")
                return
            }
            
            guard let telemetry = try? JSONDecoder().decode(TelemetryData.self, from: data) else {
                print("Failed to decode telemetry")
                return
            }
                  
            DispatchQueue.main.async {
                self.telemetry = telemetry
            }
        }.resume()
    }
}
