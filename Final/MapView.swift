//
//  MapView.swift
//  Final
//
//  Created by 林子平 on 2020/6/23.
//  Copyright © 2020 林子平. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    let coordinate: CLLocationCoordinate2D
    let title: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let regionPoint = MKPointAnnotation()
        regionPoint.coordinate = coordinate
        regionPoint.title = title
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(regionPoint)
        return mapView
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    typealias UIViewType = MKMapView
}
