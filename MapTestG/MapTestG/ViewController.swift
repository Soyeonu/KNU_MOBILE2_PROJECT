//
//  ViewController.swift
//  MapTestG
//
//  Created by soyeon on 2020/06/06.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 35.888441, longitude: 128.610536, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 35.888441, longitude: 128.610536)
        marker.title = "경북대학교"
        marker.snippet = "대구"
        marker.map = mapView
        
        
    }


}

