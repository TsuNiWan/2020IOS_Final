//
//  Bus.swift
//  Final
//
//  Created by 林子平 on 2020/6/14.
//  Copyright © 2020 林子平. All rights reserved.
//

import Foundation

struct BusTime: Codable, Identifiable {
    let id = UUID()
    let StopUID, StopID: String
    let StopName: Name
    let RouteUID: String
    let RouteID: String
    let RouteName: Name
    let StopSequence: Int?
    let Direction, StopStatus, MessageType: Int
    let SrcUpdateTime, UpdateTime: Date
    let EstimateTime: Int?
}

struct Name: Codable {
    let Zh_tw, En: String
}

struct Bus: Codable, Identifiable{
    let id = UUID()
    let RouteUID, RouteID: String
    let AuthorityID, ProviderID: String
    let BusRouteType: Int
    let RouteName: Name
    //let DepartureStopNameZh, DepartureStopNameEn: String
    //let DestinationStopNameZh, DestinationStopNameEn: String
    //let City, CityCode: String
    let UpdateTime: Date
    //let VersionID: Int
}

struct BusFavoriteData: Codable, Identifiable{
    let id = UUID()
    let RouteUID, RouteID: String
    let RouteName: Name
}

struct Position: Codable {
    let PositionLat, PositionLon: Double
}

struct BusStopPosition: Codable {
    let StopUID, StopID: String
    let StopName: Name
    let StopPosition: Position
}
