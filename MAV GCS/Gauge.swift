//
//  Gauge.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/7/25.
//

import SwiftUI

struct AirspeedGauge: View {
    var currentSpeed: Double
    
    // Gauge ranges
    let minSpeed: Double = 0
    let stallSpeed: Double = 40
    let greenStart: Double = 55
    let cruiseSpeed: Double = 80
    let yellowStart: Double = 120
    let maxSpeed: Double = 160
    
    // Angular range of the gauge
    let startAngle = -135.0
    let endAngle = 135.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let size = min(geometry.size.width, geometry.size.height)
                let radius = size / 2
                
                // Draw colored arcs
                ForEach(gaugeSegments(), id: \.self.range.lowerBound) { segment in
                    GaugeArc(
                        startValue: segment.range.lowerBound,
                        endValue: segment.range.upperBound,
                        color: segment.color,
                        minValue: minSpeed,
                        maxValue: maxSpeed,
                        startAngle: startAngle,
                        endAngle: endAngle
                    )
                    .stroke(segment.color, lineWidth: 10)
                }

                // Draw needle
                NeedleShape()
                    .fill(Color.red)
                    .frame(width: 4, height: radius * 0.9)
                    .offset(y: -radius * 0.45)
                    .rotationEffect(
                        Angle(degrees: valueToAngle(currentSpeed))
                    )
                    .animation(.easeInOut, value: currentSpeed)
                
                // Center circle
                Circle()
                    .fill(Color.black)
                    .frame(width: 20, height: 20)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    // Convert speed to angle
    private func valueToAngle(_ value: Double) -> Double {
        let clamped = min(max(value, minSpeed), maxSpeed)
        let ratio = (clamped - minSpeed) / (maxSpeed - minSpeed)
        return startAngle + ratio * (endAngle - startAngle)
    }
    
    // Define color segments
    private func gaugeSegments() -> [GaugeSegment] {
        [
            GaugeSegment(range: stallSpeed..<greenStart, color: .red),       // Stall zone
            GaugeSegment(range: greenStart..<cruiseSpeed, color: .green.opacity(0.6)), // Partial green
            GaugeSegment(range: cruiseSpeed..<yellowStart, color: .green),   // Optimal
            GaugeSegment(range: yellowStart..<maxSpeed, color: .yellow)      // Warning
        ]
    }
}

struct GaugeSegment: Hashable {
    let range: Range<Double>
    let color: Color
}

struct GaugeArc: Shape {
    let startValue: Double
    let endValue: Double
    let color: Color
    let minValue: Double
    let maxValue: Double
    let startAngle: Double
    let endAngle: Double

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - 10

        let startRatio = (startValue - minValue) / (maxValue - minValue)
        let endRatio = (endValue - minValue) / (maxValue - minValue)

        let start = Angle(degrees: startAngle + startRatio * (endAngle - startAngle))
        let end = Angle(degrees: startAngle + endRatio * (endAngle - startAngle))

        var path = Path()
        path.addArc(center: center, radius: radius,
                    startAngle: start,
                    endAngle: end,
                    clockwise: false)
        return path
    }
}

struct NeedleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))  // Top
        path.addLine(to: CGPoint(x: rect.midX + 2, y: rect.maxY))  // Bottom right
        path.addLine(to: CGPoint(x: rect.midX - 2, y: rect.maxY))  // Bottom left
        path.closeSubpath()
        return path
    }
}

#Preview {
    AirspeedGauge(currentSpeed: 5.0)
        .frame(width: 300, height: 300)
}
