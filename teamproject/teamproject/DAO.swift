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
    static var snapshot: DataSnapshot?
    
    //kind = circle
    func saveCircle(latitude: Double, longitude: Double, radius: Double, fillColor: String, strokeColor: String, strokeWidth: Float, category: String) {
        let chd = DAO.markers.child(String(arc4random()))
        
        chd.setValue(["kind": "circle", "latitude": latitude, "longitude": longitude, "radius": radius, "fillColor": fillColor, "strokeColor": strokeColor, "strokeWidth": strokeWidth, "category": category])
    }
    
    //kind = line
    func savePath(latitude: [Double], longitude: [Double], strokeColor: String, strokeWidth: Float, category: String) {
        let chd = DAO.markers.child(String(arc4random()))
        
        chd.setValue(["kind": "line", "latitude": latitude, "longitude": longitude, "strokeColor": strokeColor, "strokeWidth": strokeWidth, "category": category])
    }
    
    func loadOverlays(mapView: GMSMapView, customMarker: CustomMarker) {
        DAO.markers.observe(DataEventType.value, with: { (snapshot) in
            DAO.snapshot = snapshot
            self.drawOverlays(mapView: mapView, customMarker: customMarker)
        })
    }
    
    func drawOverlays(mapView: GMSMapView, customMarker: CustomMarker) {
        //remove all circles and lines in map (for when db is changed)
        mapView.clear()
        
        //draw new circles and lines
        let snapshotValue = DAO.snapshot?.value as? NSDictionary
        
        let keys = snapshotValue?.allKeys as! [String]

        for key in keys {
            let marker = snapshotValue?[key] as? NSDictionary
            
            let kind = marker!["kind"] as! String
            
            if kind == "circle" {
                let latitude = marker!["latitude"] as! CLLocationDegrees
                let longitude = marker!["longitude"] as! CLLocationDegrees
                let fillColor = marker!["fillColor"] as! String
                let strokeColor = marker!["strokeColor"] as! String
                let radius = marker!["radius"] as! CLLocationDistance
                let strokeWidth = marker!["strokeWidth"] as! CGFloat
                let category = marker!["category"] as! String
                
                var circle = customMarker.addCircle(latitude: latitude, longitude: longitude, radius: radius, fillColor: fillColor, strokeColor: strokeColor, strokeWidth: strokeWidth, category: category)
            } else if kind == "line" {
                let latitude = marker!["latitude"] as! [CLLocationDegrees]
                let longitude = marker!["longitude"] as! [CLLocationDegrees]
                let strokeColor = marker!["strokeColor"] as! String
                let strokeWidth = marker!["strokeWidth"] as! CGFloat
                let category = marker!["category"] as! String
                
                var line = customMarker.addLine(latitude: latitude, longitude: longitude, strokeColor: strokeColor, strokeWidth: strokeWidth, category: category)
            }
        }
    }
    
}
