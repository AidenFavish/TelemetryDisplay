//
//  ContentView.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var fetcher = TelemetryFetcher()

    var body: some View {
        ZStack {
            SixPack(telemetry: $fetcher.telemetry)
                .padding(.horizontal)
        }
        .onAppear {
            fetcher.startFetching(interval: 1.0)
        }
        .onDisappear {
            fetcher.stopFetching()
        }
    }
    
}


#Preview {
    ContentView()
}
