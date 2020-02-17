//
//  CircleImage.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 2/13/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image(uiImage: UIColor.systemRed.image(CGSize(width: 128, height: 128)))
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 8)
            
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
