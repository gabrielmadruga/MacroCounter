//
//  ContentView.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 2/12/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
            
            CircleImage()
                .offset(y: -64)
                .padding(.bottom, -64)
            
            VStack(alignment: .leading) {
                Text("Turtle Rock!")
                    .font(.title)
                HStack {
                    Text("Joshua Tree National Park").font(.subheadline)
                    Spacer()
                    Text("California")
                        .font(.subheadline)
                }
            }
            .padding()
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
