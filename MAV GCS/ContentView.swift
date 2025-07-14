//
//  ContentView.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/7/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @StateObject private var fetcher = TelemetryFetcher()
    @State var voltages: [Double] = [0.0, 0.1, 0.3, 0.5, 0.754, 1.0]
    @State var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @State var timer: Timer?
    @State var bruh: Int = 0
    @State var device_location = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.771318, longitude: -117.69482206),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    @State var drone_location = CLLocationCoordinate2D(latitude: 33.771318, longitude: -117.69482206)
    @StateObject private var locationManager = LocationManager()
    @State var heading: Double = 0.0
    
    @State var sats: Int = 6
    @State var satType: String = "NO FIX"
    @State var mode: String = "GUIDED"
    @State var armed: Bool = false
    @State var estop: Bool = false
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    @State var status_text: String = ""

    var body: some View {
        GeometryReader { geometry in
            VStack {
                InfoHeader(sats: $sats, satType: $satType, mode: $mode, armed: $armed, estop: $estop, latitude: $latitude, longitude: $longitude)
                if orientation == UIDeviceOrientation.landscapeLeft || orientation == UIDeviceOrientation.landscapeRight {
                    HStack {
                        SixPack(telemetry: fetcher, orientation: $orientation, bruh: $bruh)
                            .padding(.horizontal)
                        Spacer()
                        VStack {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(.gaugeBack)
                                    ScrollView {
                                        Text(status_text)
                                            .font(.caption)
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }.clipShape(RoundedRectangle(cornerRadius: 25))
                                }.frame(height: 175)
                                .padding(.vertical)
                                BatteryMonitor(telem: $fetcher.telemetry)
                                    .padding()
                                    .padding(.trailing, 10)
                            }
                            Spacer()
                            MapDisplay(device_location: $device_location, droneCoordinate: $drone_location, heading: $heading)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .padding(.trailing, 20)
                                .padding(.bottom)
                        }
                    }
                } else {
                    VStack {
                        SixPack(telemetry: fetcher, orientation: $orientation, bruh: $bruh)
                            .padding(.horizontal)
                            .padding(.top)
                        Spacer()
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(.gaugeBack)
                                
                                ScrollView {
                                    Text(status_text)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }.clipShape(RoundedRectangle(cornerRadius: 25))
                            }
                            .frame(height: 175)
                            .padding()
                            .padding(.leading, 20)
                            BatteryMonitor(telem: $fetcher.telemetry)
                                .padding(.trailing, 30)
                        }
                        Spacer()
                        MapDisplay(device_location: $device_location, droneCoordinate: $drone_location, heading: $heading)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding(.horizontal)
                            .padding(.horizontal)
                    }
                }
            }
            .onChange(of: geometry.size) { old_size, new_size in
                orientation = UIDevice.current.orientation
            }
            .onAppear {
                orientation = UIDevice.current.orientation
                self.startFetching(interval: 0.25)
            }
            .onDisappear {
                fetcher.stopFetching()
            }
        }
    }
    
    func startFetching(interval: TimeInterval = 1.0) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            fetcher.fetchTelemetry()
            heading = fetcher.telemetry.heading
            sats = fetcher.telemetry.sats
            satType = fetcher.telemetry.gps_fix
            mode = fetcher.telemetry.mode
            armed = fetcher.telemetry.armed
            estop = fetcher.telemetry.estop
            latitude = fetcher.telemetry.lat
            longitude = fetcher.telemetry.lon
            status_text += fetcher.telemetry.msg
            bruh += 1
            drone_location = CLLocationCoordinate2D(latitude: fetcher.telemetry.lat, longitude: fetcher.telemetry.lon)
//            device_location = MKCoordinateRegion(
//                center: locationManager.location,
//                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        }
    }
    
}


#Preview {
    ContentView()
}
