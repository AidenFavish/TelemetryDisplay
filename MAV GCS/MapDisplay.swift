//
//  MapDisplay.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/10/25.
//

import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090)

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last?.coordinate ?? CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

struct MapDisplay: View {
    @Binding var device_location: MKCoordinateRegion
    // Simulated drone location (replace with actual coordinate source)
    @Binding var droneCoordinate: CLLocationCoordinate2D
    @Binding var heading: Double

    var body: some View {
        Map(coordinateRegion: $device_location,
            interactionModes: [.zoom, .pan], // no rotation to keep north up
            showsUserLocation: true,
            annotationItems: [MapAnnotationItem(coordinate: droneCoordinate)]) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    Image(systemName: "paperplane.fill") // or use a custom asset
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.red)
                        .rotationEffect(Angle(degrees: -45 + heading))
                        .shadow(radius: 5)
                }
            }
            .mapStyle(.imagery) // iOS 17+ only
            .edgesIgnoringSafeArea(.all)
    }
}

struct MapAnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

