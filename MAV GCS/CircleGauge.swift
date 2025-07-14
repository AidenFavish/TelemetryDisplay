//
//  CircleGauge.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/8/25.
//

import SwiftUI

struct CircleGauge: View {
    let space_angle: Double = 30.0
    let radius: Double = 90.0
    let colorFunction: (Double, Double) -> Color
    let minVal: Double
    let maxVal: Double
    let unit: String
    let name: String
    let bottomLabel: String
    @Binding var value: Double
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gaugeBack)
                .frame(width: 225, height: 225)
            ForEach(generate_segments(segments: 40), id: \.self) { segment in
                NotchShape(length: 18.0, width: 7.0, angle: segment.angle, color: segment.color, offset: segment.offset)
                    
            }
            
            Text(unit)
                .font(.caption)
                .bold()
                .offset(CGSize(width: 0.0, height: 30.0))

            Text(name != "THROTTLE" ? String(format: "%.1f", value) : String(Int(round(value))))
                .font(.largeTitle)
                .bold()
                .offset(CGSize(width: 0.0, height: 0.0))
            
            Text(name)
                .font(.headline)
                .offset(CGSize(width: 0.0, height: -35.0))
            
            Text(bottomLabel)
                .bold()
                .font(.subheadline)
                .offset(CGSize(width: 0.0, height: 82.0))
            
            Text(String(Int(minVal)))
                .font(.caption)
                .offset(CGSize(width: 65.0 * cos((270.0 - space_angle) * Double.pi / 180.0), height: -65.0 * sin((270.0 - space_angle) * Double.pi / 180.0)))
            
            Text(String(Int(maxVal)))
                .font(.caption)
                .offset(CGSize(width: -65.0 * cos((270.0 - space_angle) * Double.pi / 180.0), height: -65.0 * sin((270.0 - space_angle) * Double.pi / 180.0)))
            
            Text(String(Int((maxVal - minVal) / 2.0)))
                .font(.caption)
                .offset(CGSize(width: 0.0, height: -65.0))
            
        }.frame(width: 225, height: 225)
    }
    
    private func generate_segments(segments: Int) -> [NotchSegment] {
        var segs: [NotchSegment] = []
        var angle: Double = 0.0
        let angle_between: Double = (360.0 - 2 * space_angle) / Double(segments - 1)
        for i in (0...segments-1) {
            angle = ((270 - space_angle) - angle_between * Double(i)) * Double.pi / 180.0
            segs.append(NotchSegment(offset: CGPoint(x: radius * cos(angle), y: -radius * sin(angle)), angle: -angle * 180.0 / Double.pi, color: colorFunction(Double(i + 1) / Double(segments), (value - minVal) / (maxVal - minVal))))
        }
        return segs
    }
}

func altitudeFunc(p: Double, val: Double) -> Color{
    var notchCol: Color = Color.black
    if p > 0.975 {
        notchCol = Color.red
    } else if p > 0.95 {
        notchCol = Color.orange
    } else if p > 0.925 {
        notchCol = Color.yellow
    } else if p > 0.15 {
        notchCol = Color.green
    } else if p > 0.125 {
        notchCol = Color.yellow
    } else if p > 0.1 {
        notchCol = Color.orange
    } else{
        notchCol = Color.red
    }
    
    if val < p {
        notchCol = notchCol.opacity(0.3)
    }
    
    return notchCol
}

func throttleFunc(p: Double, val: Double) -> Color{
    var notchCol: Color = Color.black
    if p > 0.95 {
        notchCol = Color.red
    } else if p > 0.9 {
        notchCol = Color.orange
    } else if p > 0.85 {
        notchCol = Color.yellow
    } else if p > 0.15 {
        notchCol = Color.green
    } else if p > 0.1 {
        notchCol = Color.yellow
    } else if p > 0.05 {
        notchCol = Color.orange
    } else{
        notchCol = Color.red
    }
    
    if val < p {
        notchCol = notchCol.opacity(0.3)
    }
    
    return notchCol
}
