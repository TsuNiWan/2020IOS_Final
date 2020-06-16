//
//  Bus.swift
//  Final
//
//  Created by 林子平 on 2020/6/14.
//  Copyright © 2020 林子平. All rights reserved.
//

import Foundation

struct BusTime: Codable {
    let StopUID, StopID: String
    let StopName: Name
    let RouteUID: String
    let RouteID: String
    let RouteName: Name
    //let SubRouteUID: String
    //let SubRouteID: String
    //let SubRouteName: Name
    let StopSequence: Int?
    let Direction, StopStatus, MessageType: Int
    let SrcUpdateTime, UpdateTime: Date
    let EstimateTime: Int?
}

struct Name: Codable {
    let Zh_tw, En: String
}

struct Bus: Codable {
    let RouteUID, RouteID: String
    //let operators: [Operator]
    let AuthorityID, ProviderID: String
    let BusRouteType: Int
    let RouteName: Name
    let DepartureStopNameZh, DepartureStopNameEn: String
    let DestinationStopNameZh, DestinationStopNameEn, TicketPriceDescriptionZh: String
    let City, CityCode: String
    let UpdateTime: Date
    let VersionID: Int
}

struct Operator: Codable {
    let OperatorID: String
    let OperatorName: Name
    let OperatorCode: String
    let OperatorNo: String
}
