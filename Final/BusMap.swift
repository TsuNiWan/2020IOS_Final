//
//  BusMap.swift
//  Final
//
//  Created by 林子平 on 2020/6/23.
//  Copyright © 2020 林子平. All rights reserved.
//

import SwiftUI
import CryptoKit
import MapKit

struct BusMap: View {
    @State private var busStop = [BusStopPosition]()
    @State private var fetchFin : Bool = false
     var localize = Bundle.main.preferredLocalizations.first
    var stopUID: String
    var lat: Double{
        if fetchFin{
            return self.busStop[0].StopPosition.PositionLat
        } else {
            return 25.0340
        }
    }
    var lon: Double{
        if fetchFin{
            return self.busStop[0].StopPosition.PositionLon
        } else {
            return 121.5645
        }
    }
    var stopName: String{
        if fetchFin{
            if localize == "zh-Hant" {
                return self.busStop[0].StopName.Zh_tw
            } else {
                return self.busStop[0].StopName.En
            }
        } else {
            return ""
        }
    }
    
    func getTimeString() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
        dateFormater.locale = Locale(identifier: "en_US")
        dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
        let time = dateFormater.string(from: Date())
        return time
    }
    
    func fetchData(stopUID: String) {
        let query = "https://ptx.transportdata.tw/MOTC/v2/Bus/Stop/City/Keelung?$filter=StopUID eq \'" + stopUID + "\'&$top=100&$format=JSON"
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
                    if let data = data, let busResults = try? decoder.decode([BusStopPosition].self, from: data) {
                        self.busStop = busResults
                        self.fetchFin = true
                    } else {
                        print("error")
                    }
                }.resume()
            }
        }
    }
    var body: some View {
        VStack {
            if self.fetchFin{
                MapView(coordinate: CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon), title: stopName)
                .frame(height: 400)
            }
        }
        .onAppear {
            self.fetchData(stopUID: self.stopUID)
        }
    }
}

struct BusMap_Previews: PreviewProvider {
    static var previews: some View {
        BusMap(stopUID: "KEE10")
    }
}
