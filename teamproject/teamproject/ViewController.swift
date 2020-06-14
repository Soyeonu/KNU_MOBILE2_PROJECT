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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 35.89, longitude: 128.61, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)        // Creates a marker in the center of the map.
        
        let dao = DAO()
//        dao.saveMarker(kind: "circle", latitude: 35.89, longitude: 128.61, radius: 100, fillColor: "red", strokeColor: "red", strokeWidth: 10.0)
        
        dao.loadMarkers(mapView: mapView)
    }
    
    
    
    	


}

