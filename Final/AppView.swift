//
//  AppView.swift
//  Final
//
//  Created by 林子平 on 2020/6/16.
//  Copyright © 2020 林子平. All rights reserved.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            BusList()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("測試")
            }
            BusEstimatedTimeOfArrival(title: "104 新豐街-經中正路", routeUID: "KEE1041")
                .tabItem {
                    Image(systemName: "clock")
                    Text("到站時間")
            }
            ImagePicker()
                .tabItem {
                    Image(systemName: "photo")
                    Text("圖片挑選")
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
