//
//  AppView.swift
//  Final
//
//  Created by 林子平 on 2020/6/16.
//  Copyright © 2020 林子平. All rights reserved.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var busFavorite: BusFavorite
    
    var body: some View {
        TabView {
            BusList()
                .tabItem {
                    Image(systemName: "clock")
                    Text(NSLocalizedString("busInfo", comment: ""))
            }
            BusFavoriteList()
                .tabItem {
                    Image(systemName: "heart.circle")
                    Text(NSLocalizedString("myFavorite", comment: ""))
            }
            OtherFunction()
                .tabItem {
                    Image(systemName: "photo")
                    Text(NSLocalizedString("picSelect", comment: ""))
            }
        }
        .environmentObject(busFavorite)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView().environmentObject(BusFavorite())
    }
}
