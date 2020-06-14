//
//  ViewController.swift
//  teamproject
//
//  Created by hmt on 2020/06/09.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    var customMarker: CustomMarker? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 35.89, longitude: 128.61, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
        
        let dao = DAO()
        dao.saveMarker(kind: "circle", latitude: 35.89, longitude: 128.61, radius: 100, fillColor: "red", strokeColor: "red", strokeWidth: 10.0, category: "person")
        
        customMarker = CustomMarker(mapView: mapView)
        dao.loadMarkers(mapView: mapView, customMarker: customMarker!)
    }
    
    
    @IBAction func TestButton(_ sender: Any) {
        if let customMarker = customMarker {
            customMarker.hideMarkerByCategory(category: "person")
        }
    }
    
    	


}

