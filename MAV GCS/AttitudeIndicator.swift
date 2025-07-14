//
//  AttitudeIndicator.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/13/25.
//

import SwiftUI

struct AttitudeIndicator: View {
    @Binding var pitch: Double // in degrees, + is nose up
    @Binding var roll: Double  // in degrees, + is right bank

    var body: some View {
        ZStack {
            Circle()
                .fill(.gaugeBack)
                .frame(width: 225, height: 225)
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                let pitchLimit: Double = 45  // degrees to max render up/down
                
                ZStack {
                    // Horizon background
                    HorizonView(pitch: pitch, roll: roll)
                        .frame(width: size * 4, height: size * 4)
                        .rotationEffect(Angle(degrees: roll))
                        .offset(y: CGFloat(-pitch / pitchLimit) * size / 2)
                    
                    // Foreground mask (circular bezel)
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 4)
                        .background(Circle().fill(Color.clear))
                    
                    Image(systemName: "triangleshape.fill")
                        .resizable()
                        .frame(width: 100, height: 20)
                        .foregroundStyle(.orange)
                        .offset(CGSize(width: 0, height: 10))
                }
                .frame(width: size, height: size)
                .clipped()
            }.frame(width: 200, height: 200)
            .clipShape(Circle())
        }
        
    }
}

struct HorizonView: View {
    var pitch: Double
    var roll: Double

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.blue
                Color.brown
            }
            Capsule()
                .frame(width: 25, height: 5)
                .foregroundStyle(.white)
                .offset(CGSize(width: 0, height: -20))
            Capsule()
                .frame(width: 50, height: 5)
                .foregroundStyle(.white)
                .offset(CGSize(width: 0, height: -40))
            Capsule()
                .frame(width: 25, height: 5)
                .foregroundStyle(.white)
                .offset(CGSize(width: 0, height: -60))
            Capsule()
                .frame(width: 100, height: 5)
                .foregroundStyle(.white)
                .offset(CGSize(width: 0, height: -80))
            Capsule()
                .frame(width: 300, height: 5)
                .foregroundStyle(.white)
            Capsule()
                .frame(width: 25, height: 5)
                .foregroundStyle(.white)
                .offset(CGSize(width: 0, height: 20))
            Capsule()
                .frame(width: 50, height: 5)
                .foregroundStyle(.white)
                .offset(CGSize(width: 0, height: 40))
            Capsule()
                .frame(width: 25, height: 5)
                .foregroundStyle(.white)
                .offset(CGSize(width: 0, height: 60))
            Capsule()
                .frame(width: 100, height: 5)
                .foregroundStyle(.white)
                .offset(CGSize(width: 0, height: 80))
            Text("40")
                .foregroundStyle(.white)
                .bold()
                .offset(CGSize(width: 65, height: 80))
            Text("40")
                .foregroundStyle(.white)
                .bold()
                .offset(CGSize(width: -65, height: 80))
            Text("20")
                .foregroundStyle(.white)
                .bold()
                .offset(CGSize(width: 40, height: 40))
            Text("20")
                .foregroundStyle(.white)
                .bold()
                .offset(CGSize(width: -40, height: 40))
            Text("40")
                .foregroundStyle(.white)
                .bold()
                .offset(CGSize(width: 65, height: -80))
            Text("40")
                .foregroundStyle(.white)
                .bold()
                .offset(CGSize(width: -65, height: -80))
            Text("20")
                .foregroundStyle(.white)
                .bold()
                .offset(CGSize(width: 40, height: -40))
            Text("20")
                .foregroundStyle(.white)
                .bold()
                .offset(CGSize(width: -40, height: -40))
        }
    }
}
