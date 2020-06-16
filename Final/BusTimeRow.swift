//
//  BusTimeRow.swift
//  Final
//
//  Created by 林子平 on 2020/6/16.
//  Copyright © 2020 林子平. All rights reserved.
//

import SwiftUI

struct BusTimeRow: View {
    var bus:BusTime
    var body: some View {
        HStack {
            if bus.EstimateTime != nil{
                Text(bus.StopName.Zh_tw)
                Spacer()
                Text("\(bus.EstimateTime!/60) 分鐘")
            } else {
                Text(bus.StopName.Zh_tw)
                Spacer()
                Text("未發車")
            }
        }
        .padding()
    }
}

struct BusTimeRow_Previews: PreviewProvider {
    static var previews: some View {
        BusTimeRow(bus: BusTime(StopUID:"KEE29",StopID:"29", StopName: Name(Zh_tw:"忠一路孝一路口",En:"Zhong 1st Rd. & Xiao 1st Rd. Intersection"),RouteUID:"KEE1041",RouteID:"1041", RouteName:Name(Zh_tw:"104 新豐街-經中正路",En:"104 Xinfeng St. - Via Zhongzheng Rd."),StopSequence:1,Direction:1,StopStatus:0,MessageType:0,SrcUpdateTime:Date(),UpdateTime:Date(),EstimateTime:1320))
    }
}
