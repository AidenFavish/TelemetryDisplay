//
//  Telemetry.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/7/25.
//

import Foundation
import Combine

struct TelemetryData: Codable {
    let msg_id: Int
    
    let heading: Double
    
    let airspeed: Double
    let verticalSpeed: Double
    let horizontalSpeed: Double
    
    let altitudeASL: Double
    
    let heartbeatId: Int
    let heartbeatHZ: Double
    
    let throttle: Double
}

class TelemetryFetcher: ObservableObject {
    @Published var telemetry: TelemetryData = TelemetryData(msg_id: 0, heading: 0, airspeed: 0, verticalSpeed: 0, horizontalSpeed: 0, altitudeASL: 0, heartbeatId: 0, heartbeatHZ: 0, throttle: 0)
    var beat: (() -> Void)?
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

    private func fetchTelemetry() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let telemetry = try? JSONDecoder().decode(TelemetryData.self, from: data) else {
                print("Failed to decode telemetry")
                return
            }
            DispatchQueue.main.async {
                self.telemetry = telemetry
            }
        }.resume()
    }
}
