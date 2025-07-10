//
//  heartbeat.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/9/25.
//

import SwiftUI

struct Heartbeat: View {
    @Binding var isBeating: Bool
    @Binding var hz: Double

    var body: some View {
        ZStack() {
            Circle()
                .fill(Color.gaugeBack)
            
            Image(systemName: "heart.fill")
                .resizable()
                .frame(width: 125, height: 125)
                .offset(x: 0.0, y: 10.0)
                .foregroundColor(isBeating ? .red : .heartBack)
                .scaleEffect(isBeating ? 1.3 : 1.0)
                .animation(.easeOut(duration: isBeating ? 0.2 : 1.5), value: isBeating)
            
            Text(String(format: "%.2f", hz))
                .font(.title)
                .bold()
                .foregroundStyle(.white)
            
            Text("HZ")
                .offset(CGSize(width: 0.0, height: 30.0))
                .bold()
                .foregroundStyle(.white)

        }.frame(width: 225, height: 225)
    }

    func beatOnce() {
        isBeating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isBeating = false
        }
    }
}



