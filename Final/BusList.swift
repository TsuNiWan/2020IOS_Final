//
//  BusList.swift
//  Final
//
//  Created by 林子平 on 2020/6/14.
//  Copyright © 2020 林子平. All rights reserved.
//

import SwiftUI
import CryptoKit

struct BusList: View {
    @EnvironmentObject var busFavorite: BusFavorite
    @State private var bus = [Bus]()
    @State private var searchText : String = ""
    
    var localize = Bundle.main.preferredLocalizations.first
    var filteredBus: [Bus] {
        return bus.filter { self.searchText.isEmpty ? true : $0.RouteUID.lowercased().contains(searchText.lowercased()) }
    }
    
    func getTimeString() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
        dateFormater.locale = Locale(identifier: "en_US")
        dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
        let time = dateFormater.string(from: Date())
        return time
    }
    
    func fetchData() {
        let query = "https://ptx.transportdata.tw/MOTC/v2/Bus/Route/City/Keelung?$top=100&$format=JSON"
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
                    if let data = data, let busResults = try? decoder.decode([Bus].self, from: data) {
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
                SearchBar(text: self.$searchText, placeholder: NSLocalizedString("busSelect", comment: ""))
                if localize == "zh-Hant" {
                    List(filteredBus.indices, id: \.self) { (index)  in
                        NavigationLink(destination: BusEstimatedTimeOfArrival(routeUID: self.filteredBus[index].RouteUID, routeID: self.filteredBus[index].RouteID, routeName: self.filteredBus[index].RouteName)){
                            Text(self.filteredBus[index].RouteName.Zh_tw)
                        }
                    }
                } else {
                    List(filteredBus.indices, id: \.self) { (index)  in
                        NavigationLink(destination: BusEstimatedTimeOfArrival(routeUID: self.filteredBus[index].RouteUID, routeID: self.filteredBus[index].RouteID, routeName: self.filteredBus[index].RouteName)) {
                            Text(self.filteredBus[index].RouteName.En)
                        }
                    }
                }
            }
            .onAppear {
                self.fetchData()
            }
            .navigationBarTitle(NSLocalizedString("busInfo", comment: ""))
        }
    }
}


struct BusList_Previews: PreviewProvider {
    static var previews: some View {
        BusList()
    }
}
