//
//  BusEstimatedTimeOfArrival.swift
//  Final
//
//  Created by 林子平 on 2020/6/16.
//  Copyright © 2020 林子平. All rights reserved.
//

import SwiftUI
import CryptoKit
import SwiftUIPullToRefresh

struct BusEstimatedTimeOfArrival: View {
    @State private var bus = [BusTime]()
    var title: String
    var routeUID: String
    var direction = ["去程", "返程"]
    @State var showRefreshView = false
    @State private var selectDirection: String = "去程"
    
    func getTimeString() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
        dateFormater.locale = Locale(identifier: "en_US")
        dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
        let time = dateFormater.string(from: Date())
        return time
    }
    
    func fetchData(routeUID: String, busDirection: String) {
        let query = "https://ptx.transportdata.tw/MOTC/v2/Bus/EstimatedTimeOfArrival/City/Keelung?$filter=RouteUID eq \'" + routeUID + "\' and Direction eq " + busDirection + "&$orderby= StopSequence asc&$top=100&$format=JSON"
        if let urlStr = query.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) {
            if let url = URL(string: urlStr) {
                let appId = "ef371fafd07144868904b4208043e106"
                let appKey = "XFO1Vb3pZtwmkmyv9mSsmMmYo74"
                let xdate = getTimeString()
                let signDate = "x-date: \(xdate)"
                let key = SymmetricKey(data: Data(appKey.utf8))
                let hmac = HMAC<SHA256>.authenticationCode(for: Data(signDate.utf8), using: key)
                let base64HmacString = Data(hmac).base64EncodedString()
                let authorization:String = "hmac username=\"" + appId + "\", algorithm=\"hmac-sha256\", headers=\"x-date\", signature=\"" + base64HmacString + "\""
                var request = URLRequest(url: url)
                request.setValue(xdate, forHTTPHeaderField: "x-date")
                request.setValue(authorization, forHTTPHeaderField: "Authorization")
                request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    if let data = data, let busResults = try? decoder.decode([BusTime].self, from: data) {
                        self.bus = busResults
                    } else {
                        print("error")
                    }
                }.resume()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: self.$selectDirection, label: Text("請選擇旅程方向：")) {
                    ForEach(self.direction, id: \.self) {
                        (text) in Text(text)
                    }
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .padding(20)
                
                if selectDirection == "去程" {
                    RefreshableList(showRefreshView: $showRefreshView, action:{
                        self.fetchData(routeUID: self.routeUID, busDirection: "0")
                        // Remember to set the showRefreshView to false
                        self.showRefreshView = false
                    }){
                        VStack {
                            ForEach(self.bus.indices, id: \.self) { (index)  in
                                BusTimeRow(bus: self.bus[index])
                            }
                        }
                        
                    }
                    .onAppear {
                        //self.bus.removeAll()
                        self.fetchData(routeUID: self.routeUID, busDirection: "0")
                    }
                } else {
                    RefreshableList(showRefreshView: $showRefreshView, action:{
                        self.fetchData(routeUID: self.routeUID, busDirection: "1")
                        // Remember to set the showRefreshView to false
                        self.showRefreshView = false
                    }){
                        VStack {
                            ForEach(self.bus.indices, id: \.self) { (index)  in
                                BusTimeRow(bus: self.bus[index])
                            }
                        }
                    }
                    .onAppear {
                        //self.bus.removeAll()
                        self.fetchData(routeUID: self.routeUID, busDirection: "1")
                    }
                }
            }
            .navigationBarTitle(title)
        }
    }
}

struct BusEstimatedTimeOfArrival_Previews: PreviewProvider {
    static var previews: some View {
        BusEstimatedTimeOfArrival(title: "104 新豐街-經中正路", routeUID: "KEE1041")
    }
}
