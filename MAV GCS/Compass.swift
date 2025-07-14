//
//  Compass.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/8/25.
//

import SwiftUI

struct Compass: View {
    @Binding var heading: Double
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("gaugeBack"))
                .frame(width: 225, height: 225)
            Image("compass")
                .resizable(resizingMode: .stretch)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-heading))
                .animation(.easeInOut(duration: 0.25), value: true)
            Image(systemName: "airplane")
                .foregroundStyle(.white)
                .font(.custom("big", size: 35))
                .rotationEffect(.degrees(-90))
                .frame(width: 50, height: 50)
            Text(String(Int(heading)) + "°")
                .bold()
                .foregroundStyle(.white)
                .offset(CGSize(width: 0.0, height: 35.0))
            
        }
        .frame(width: 225, height: 225)
    }
}
