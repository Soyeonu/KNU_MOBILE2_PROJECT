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
//        dao.saveCircle(latitude: 35.89, longitude: 128.61, radius: 100, fillColor: "red", strokeColor: "red", strokeWidth: 10.0, category: "person")
//        dao.savePath(latitude: [35.892382, 35.891287, 35.887802, 35.885689], longitude: [128.609356, 128.610074, 128.609120, 128.609055], strokeColor: "purple", strokeWidth: 10, category: "river")
        
        customMarker = CustomMarker(mapView: mapView)
        dao.loadOverlays(mapView: mapView, customMarker: customMarker!)
    }
    
    
    @IBAction func TestButton(_ sender: Any) {
        if let customMarker = customMarker {
            customMarker.hideMarkerByCategory(category: "person")
        }
    }
    
    	


}

