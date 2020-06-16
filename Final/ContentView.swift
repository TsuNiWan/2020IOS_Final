//
//  ContentView.swift
//  Final
//
//  Created by 林子平 on 2020/5/27.
//  Copyright © 2020 林子平. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var scale:CGFloat = 1
    @State private var newScale:CGFloat = 1
    var body: some View {
        Image(systemName: "car.fill")
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
            .clipped()
            .scaleEffect(scale)
            .gesture(MagnificationGesture()
                .onChanged{ value in
                    self.scale = self.newScale * value.magnitude
            }.onEnded({ value in
                self.newScale = self.scale
            }))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
