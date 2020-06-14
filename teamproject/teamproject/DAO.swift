//
//  DAO.swift
//  teamproject
//
//  Created by hmt on 2020/06/14.
//  Copyright © 2020 COMP420. All rights reserved.
//

import Foundation
import GoogleMaps
import Firebase

class DAO {
    
    static let ref: DatabaseReference! = Database.database().reference()
    static let markers = ref.child("markers")
    
    //kind = marker, circle, line
    func saveMarker(kind: String, latitude: Double, longitude: Double, radius: Double, fillColor: String, strokeColor: String, strokeWidth: Float, category: String) {
        let chd = DAO.markers.child(String(arc4random()))
        chd.setValue(["kind": kind, "latitude": latitude, "longitude": longitude, "radius": radius, "fillColor": fillColor, "strokeColor": strokeColor, "strokeWidth": strokeWidth, "category": category])
    }
    
    func loadMarkers(mapView: GMSMapView, customMarker: CustomMarker) {
        DAO.markers.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as? NSDictionary
            
            let keys = snapshotValue?.allKeys as! [String]

            for key in keys {
                let marker = snapshotValue?[key] as? NSDictionary
                
                let kind = marker!["kind"] as! String
                let latitude = marker!["latitude"] as! CLLocationDegrees
                let longitude = marker!["longitude"] as! CLLocationDegrees
                let fillColor = marker!["fillColor"] as! String
                let strokeColor = marker!["strokeColor"] as! String
                let radius = marker!["radius"] as! CLLocationDistance
                let strokeWidth = marker!["strokeWidth"] as! CGFloat
                let category = marker!["category"] as! String
                
                if kind == "circle" {
                    var circle = customMarker.addCircle(latitude: latitude, longitude: longitude, radius: radius, fillColor: fillColor, strokeColor: strokeColor, strokeWidth: strokeWidth, category: category)
                } else if kind == "line" {
                    //....
                }
            }
        })
    }
    
}
