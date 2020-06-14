//
//  CustomMarker.swift
//  teamproject
//
//  Created by hmt on 2020/06/12.
//  Copyright © 2020 COMP420. All rights reserved.
//

import Foundation
import GoogleMaps

class CustomMarker {
    
    let mapView: GMSMapView
    
    init(mapView: GMSMapView) {
        self.mapView = mapView
    }
    
    func addMarker(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String?, description: String?) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        if let title = title {
            marker.title = title
        }
        if let description = description {
            marker.snippet = description
        }
        marker.map = mapView
        
        return marker;
    }
    
    func addCircle(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: CLLocationDistance, fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) -> GMSCircle {
        
        let circleCenter = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let circ = GMSCircle(position: circleCenter, radius: radius)
        circ.fillColor = fillColor
        circ.strokeColor = strokeColor
        circ.strokeWidth = strokeWidth
        circ.map = mapView
        
        return circ
    }
    
    func addCircle(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: CLLocationDistance, fillColor: String, strokeColor: String, strokeWidth: CGFloat) -> GMSCircle {
        
        return addCircle(latitude: latitude, longitude: longitude, radius: radius, fillColor: str2UIColor(color: fillColor), strokeColor: str2UIColor(color: strokeColor), strokeWidth: strokeWidth)
    }
    
    func str2UIColor(color: String) -> UIColor {
        
        switch color {
        case "red":
            return UIColor.red
        case "orange":
            return UIColor.orange
        case "yellow":
            return UIColor.yellow
        case "green":
            return UIColor.green
        case "blue":
            return UIColor.blue
        case "brown":
            return UIColor.brown
        case "purple":
            return UIColor.purple
        case "black":
            return UIColor.black
        case "white":
            return UIColor.white
        default:
            return UIColor.red
        }
    }
    
}
