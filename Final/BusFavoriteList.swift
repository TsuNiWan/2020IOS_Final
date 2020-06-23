//
//  BusFavoriteList.swift
//  Final
//
//  Created by 林子平 on 2020/6/22.
//  Copyright © 2020 林子平. All rights reserved.
//

import SwiftUI

struct BusFavoriteList: View {
    @EnvironmentObject var busFavoriteList: BusFavorite
    var localize = Bundle.main.preferredLocalizations.first

    var body: some View {
        NavigationView {
            List {
                ForEach(busFavoriteList.bus) { (bus) in
                    if self.localize == "zh-Hant" {
                        NavigationLink(destination: BusEstimatedTimeOfArrival( routeUID: bus.RouteUID, routeID: bus.RouteID, routeName: bus.RouteName)) {
                            Text(bus.RouteName.Zh_tw)
                        }
                    } else {
                        NavigationLink(destination: BusEstimatedTimeOfArrival( routeUID: bus.RouteUID, routeID: bus.RouteID, routeName: bus.RouteName)) {
                            Text(bus.RouteName.En)
                        }
                    }
                    
                }
                .onDelete { (indexSet) in
                    self.busFavoriteList.bus.remove(atOffsets: indexSet)
                }
                .onMove { (indexSet, index) in
                    self.busFavoriteList.bus.move(fromOffsets: indexSet, toOffset: index)
                }
            }
            .navigationBarTitle(NSLocalizedString("myFavorite", comment: ""))
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct BusFavoriteList_Previews: PreviewProvider {
    static var previews: some View {
        BusFavoriteList().environmentObject(BusFavorite())
    }
}
