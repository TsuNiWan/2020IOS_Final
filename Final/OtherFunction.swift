//
//  OtherFunction.swift
//  Final
//
//  Created by 林子平 on 2020/6/23.
//  Copyright © 2020 林子平. All rights reserved.
//

import SwiftUI

struct OtherFunction: View {
    @State private var scale:CGFloat = 1
    @State private var newScale:CGFloat = 1
    @State private var selectImage = Image(systemName: "photo")
    @State private var showSelectPhoto = false
    
    var body: some View {
        NavigationView {
            Button(action: {
                self.showSelectPhoto = true
            }) {
                selectImage
                    .resizable()
                    .scaledToFill()
                    .frame(width:200, height:200)
                    .clipped()
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showSelectPhoto) {
                ImagePickerController(selectImage: self.$selectImage, showSelectPhoto:
                    self.$showSelectPhoto)
            }
            .navigationBarTitle(NSLocalizedString("picture", comment: ""))
        }
    }
}

struct OtherFunction_Previews: PreviewProvider {
    static var previews: some View {
        OtherFunction()
    }
}
