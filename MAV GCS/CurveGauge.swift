//
//  CurveGauge.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/7/25.
//

import SwiftUI

struct CurveGauge: View {
    let radius: Double = 100.0
    let segments: Int = 15
    let angle_tilt: Double = 30.0
    let length: Double = 20.0
    let thickness: Double = 7.0
    let low_color: Color
    let high_color: Color
    let min_value: Double
    let max_value: Double
    let units: String
    let name: String
    let image: String
    @Binding var value: Double
    var body: some View {
        GeometryReader {geometry in
            ZStack {
                ForEach(generateSegments(segments: segments, max_angle: angle_tilt, radius: radius), id: \.self.offset) { segment in
                    NotchShape(length: length, width: thickness, angle: segment.angle, color: segment.color, offset: segment.offset)
                    
                }
                Text(String(Int(min_value)))
                    .offset(x: -65.0, y: 10.0)
                Text(String(Int(max_value)))
                    .offset(x: 65.0, y: 10.0)
                Text(String(Int((max_value + min_value) / 2.0)))
                    .offset(x: 0.0, y: -25.0)
                VStack {
                    Spacer()
                    Text(String(Int(value)))
                        .font(.title)
                        .bold()
                        .offset(x: 0, y: 7.0)
                    Text(units)
                    if image == "" {
                        Text(name)
                            .font(.title2)
                            .bold()
                    } else {
                        Label(name, systemImage: image)
                            .font(.title2)
                            .bold()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func generateSegments(segments: Int, max_angle: Double, radius: Double) -> [NotchSegment] {
        let angleDiff = 2 * (90 - max_angle) / Double(segments - 1)
        let y_offset = radius * sin(max_angle * Double.pi / 180.0) + (radius - radius * sin(max_angle * Double.pi / 180.0)) / 2 - length
        var angle = 0.0
        var output: [NotchSegment] = []
        var the_color = low_color
        for i in (0...segments-1) {
            angle = max_angle + Double(i) * angleDiff
            if min_value < 0.0 && ((value <= 0.0 && (Double(i) + 1.0) / Double(segments) >= (value - min_value) / (max_value - min_value) && (Double(i) + 1.0) / Double(segments) <= 0.5) || (value >= 0.0 && (Double(i) + 1.0) / Double(segments) <= (value - min_value) / (max_value - min_value) && (Double(i) + 1.0) / Double(segments) >= 0.5)) {
                the_color = high_color
            } else if min_value >= 0.0 && (Double(i) + 1.0) / Double(segments) < (value - min_value) / (max_value - min_value) {
                the_color = high_color
            } else {
                the_color = low_color
            }
            output.append(NotchSegment(offset: CGPoint(x: -radius * cos(angle * Double.pi / 180.0), y: y_offset - radius * sin(angle * Double.pi / 180.0)), angle: angle, color: the_color))
        }
        return output
    }
}

struct NotchSegment: Hashable {
    let offset: CGPoint
    let angle: Double
    let color: Color
}


struct NotchShape: View {
    let length: Double
    let width: Double
    let angle: Double
    let color: Color
    let offset: CGPoint
    
    var body: some View {
        Capsule()
            .fill(color)
            .frame(width: length, height: width)
            .rotationEffect(Angle(degrees: angle))
            .offset(x: offset.x, y: offset.y)
            
    }
}
