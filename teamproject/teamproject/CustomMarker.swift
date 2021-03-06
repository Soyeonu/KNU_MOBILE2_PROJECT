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
    
    static var markerAlpha:CGFloat = 1.0
    
    var markerDictionary = [String: [Any]]()
    /*
     * markerDictionary = {
     *  "person": [circle1, circle2, ...]
     *  "river": [path1, path2, ...]
     * }
     */
    var hiddenCategory = [String: Bool]() //false == hidden, true == shown
    
    init(mapView: GMSMapView) {
        self.mapView = mapView
    }
    
    func clearMarkerDictionary() {
        markerDictionary.removeAll()
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
    
    func addCircle(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: CLLocationDistance, fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat, category: String) -> GMSCircle {
        
        let circleCenter = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let circ = GMSCircle(position: circleCenter, radius: radius)
        circ.fillColor = fillColor.withAlphaComponent(CustomMarker.markerAlpha)
        circ.strokeColor = strokeColor.withAlphaComponent(CustomMarker.markerAlpha)
        circ.strokeWidth = strokeWidth
        circ.map = isHiddenCategory(category) ? nil : mapView
        
        append(category: category, wantToAdd: circ)
        	
        return circ
    }
    
    func addCircle(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: CLLocationDistance, fillColor: String, strokeColor: String, strokeWidth: CGFloat, category: String) -> GMSCircle {
        
        return addCircle(latitude: latitude, longitude: longitude, radius: radius, fillColor: str2UIColor(fillColor), strokeColor: str2UIColor(strokeColor), strokeWidth: strokeWidth, category: category)
    }
    
    func addLine(latitude: [CLLocationDegrees], longitude: [CLLocationDegrees], strokeColor: UIColor, strokeWidth: CGFloat, category: String) -> GMSPolyline {
        
        let path = GMSMutablePath()
        for i in 0..<latitude.count {
            path.add(CLLocationCoordinate2D(latitude: latitude[i], longitude: longitude[i]))
        }
        
        let line = GMSPolyline(path: path)
        line.strokeWidth = strokeWidth
        line.strokeColor = strokeColor.withAlphaComponent(CustomMarker.markerAlpha)
        line.map = isHiddenCategory(category) ? nil : mapView
        
        append(category: category, wantToAdd: line)
        
        return line
    }
    
    func addLine(latitude: [CLLocationDegrees], longitude: [CLLocationDegrees], strokeColor: String, strokeWidth: CGFloat, category: String) -> GMSPolyline {
        
        return addLine(latitude: latitude, longitude: longitude, strokeColor: str2UIColor(strokeColor), strokeWidth: strokeWidth, category: category)
    }
    
    func str2UIColor(_ color: String) -> UIColor {
        
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
    
    //markerDictionary = {"a": [1]} -> append("a", 2); append("b", "hi") -> markerDictionary = {"a": [1, 2], "b": "hi"}
    func append(category: String, wantToAdd: Any) {
        var arr = markerDictionary[category] as? Array<Any> ?? [Any]()
        arr.append(wantToAdd)
        
        markerDictionary.updateValue(arr, forKey: category)
        
//        print(markerDictionary)
    }
    
    func hideMarkerByCategory(_ category: String) {
        if let arr = markerDictionary[category] as? Array<GMSOverlay> {
            for overlay in arr {
                overlay.map = nil
            }
        }
    }
    
    func showMarkerByCategory(_ category: String) {
        if let arr = markerDictionary[category] as? Array<GMSOverlay> {
            for overlay in arr {
                overlay.map = mapView
            }
        }
    }
    
    func addHiddenCategory(_ category: String) {
        hiddenCategory[category] = true
    }
    
    func removeHiddenCategory(_ category: String) {
        hiddenCategory[category] = false
    }
    
    func isHiddenCategory(_ category: String) -> Bool {
        return hiddenCategory[category] ?? false //deafult is false(not hidden)
    }
    
    func setAlpha(_ alpha: CGFloat) {
        CustomMarker.markerAlpha = alpha
        
        let categories = Array(markerDictionary.values)
        for markers in categories {
            for m in markers {
                if let m = m as? GMSCircle {
                    //change to new alpha
                    m.fillColor = m.fillColor?.withAlphaComponent(alpha)
                    m.strokeColor = m.strokeColor?.withAlphaComponent(alpha)
                } else if let m = m as? GMSPolyline {
                    //change to new alpha (poly line has no fillColor)
                    m.strokeColor = m.strokeColor.withAlphaComponent(alpha)
                }
            }
        }
    }
    
}
