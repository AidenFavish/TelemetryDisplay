//
//  CellMonitor.swift
//  MAV GCS
//
//  Created by Aiden Favish on 7/10/25.
//

import SwiftUI

struct CellMonitor: View {
    @Binding var cellPercent: Double
    let name: String
    var body: some View {
        HStack {
            Text(name)
            GeometryReader { geometry in
                ZStack {
                    Capsule()
                        .fill(.heartBack)
                    Capsule()
                        .fill(.back)
                        .frame(width: geometry.size.width - 3.0, height: geometry.size.height - 3.0)
                    HStack {
                        Capsule()
                            .fill(.green)
                            .frame(width: (geometry.size.width - 3.0) * CGFloat(cellPercent))
                            .animation(.easeInOut(duration: 0.25), value: true)
                            .padding(1.5)
                        Spacer(minLength: 0.0)
                    }
                    Text("\(Int(cellPercent * 100.0))%")
                        .font(.caption)
                }
            }
        }.frame(width: 130.0, height: 18.0)
    }
}
