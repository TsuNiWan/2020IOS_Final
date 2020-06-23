//
//  BusEstimatedTimeOfArrival.swift
//  Final
//
//  Created by 林子平 on 2020/6/16.
//  Copyright © 2020 林子平. All rights reserved.
//

import SwiftUI
import UIKit
import CryptoKit
import SwiftUIPullToRefresh

extension UIAlertController {
    static func showAlert(message: String, in viewController: UIViewController) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        viewController.present(controller, animated: true, completion: nil)
    }
    
    static func showAlert(message: String) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(message: message, in: vc)
        }
    }
}

struct BusEstimatedTimeOfArrival: View {
    @EnvironmentObject var busFavorite: BusFavorite
    @State private var busTime = [BusTime]()
    @State private var stopUID: String = ""
    @State private var showMap = false
    
    var localize = Bundle.main.preferredLocalizations.first
    var routeUID: String
    var routeID: String
    var routeName: Name
    var title: String{
        if localize == "zh-Hant" {
            return routeName.Zh_tw
        } else {
            return routeName.En
        }
    }
    var direction = [NSLocalizedString("departure", comment: ""), NSLocalizedString("return", comment: "")]
    var editText: String{
        for index in busFavorite.bus.indices{
            if busFavorite.bus[index].RouteUID == routeUID {
                return NSLocalizedString("dislike", comment: "")
            }
        }
        return NSLocalizedString("like", comment: "")
    }
    @State var showRefreshView = false
    @State private var selectDirection = NSLocalizedString("departure", comment: "")
    @State var show = 0
    var isFavorite: Int{
        for index in busFavorite.bus.indices{
            if busFavorite.bus[index].RouteUID == routeUID {
                return 1
            }
        }
        return 0
    }
    
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
                        self.busTime = busResults
                    } else {
                        print("error")
                    }
                }.resume()
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Picker(selection: self.$selectDirection, label: Text("請選擇旅程方向：")) {
                    ForEach(self.direction, id: \.self) {
                        (text) in Text(text)
                    }
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .padding(20)
            }
            
            if selectDirection == NSLocalizedString("departure", comment: ""){
                RefreshableList(showRefreshView: $showRefreshView, action:{
                    self.fetchData(routeUID: self.routeUID, busDirection: "0")
                    // Remember to set the showRefreshView to false
                    self.showRefreshView = false
                }){
                    VStack {
                        ForEach(self.busTime.indices, id: \.self) { (index)  in
                            BusTimeRow(bus: self.busTime[index])
                            .onLongPressGesture(minimumDuration: 2){
                                self.showMap = true
                                self.stopUID = self.busTime[index].StopUID
                            }
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
                        ForEach(self.busTime.indices, id: \.self) { (index)  in
                            BusTimeRow(bus: self.busTime[index])
                            .onLongPressGesture(minimumDuration: 2){
                                self.showMap = true
                                self.stopUID = self.busTime[index].StopUID
                            }
                        }
                    }
                }
                .onAppear {
                    //self.bus.removeAll()
                    self.fetchData(routeUID: self.routeUID, busDirection: "1")
                }
            }
        }
        .sheet(isPresented: self.$showMap) {
            BusMap(stopUID: self.stopUID)
        }
        .navigationBarTitle(title)
        .navigationBarItems(trailing: Button(editText){
            let mybus = BusFavoriteData(RouteUID: self.routeUID, RouteID: self.routeID, RouteName: Name(Zh_tw: self.routeName.Zh_tw, En: self.routeName.En))
            
            if self.isFavorite != 1{
                UIAlertController.showAlert(message: NSLocalizedString("add", comment: ""))
                self.busFavorite.bus.insert(mybus, at: 0)
            } else {
                UIAlertController.showAlert(message: NSLocalizedString("remove", comment: ""))
                let index = self.busFavorite.bus.firstIndex{
                    $0.RouteUID == self.routeUID
                    }!
                self.busFavorite.bus.remove(at: index)
            }
        })
    }
}

struct BusEstimatedTimeOfArrival_Previews: PreviewProvider {
    static var previews: some View {
        BusEstimatedTimeOfArrival(routeUID: "KEE1041", routeID: "1041", routeName: Name(Zh_tw: "104 新豐街-經中正路", En: "104 Xinfeng St. - Via Zhongzheng Rd."))
    }
}
