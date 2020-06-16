//
//  ViewController.swift
//  teamproject
//
//  Created by hmt on 2020/06/09.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {
    
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
    
    @IBOutlet weak var OptionView: UIView!
    
    @IBAction func FilterButton(_ sender: Any) {
        OptionView.alpha = 1.0 //show option view
    }
    
    @IBAction func OptionOKButton(_ sender: Any) {
        OptionView.alpha = 0.0 //hide option view
    }
    
    @IBAction func PeopleSwitch(_ sender: UISwitch) {
        optionSwitchHandler(sender: sender, category: "people")
    }
    @IBAction func RiverSwitch(_ sender: UISwitch) {
        optionSwitchHandler(sender: sender, category: "river")
    }
    @IBAction func GroundAnimalSwitch(_ sender: UISwitch) {
        optionSwitchHandler(sender: sender, category: "ground_animal")
    }
    @IBAction func InsectSwitch(_ sender: UISwitch) {
        optionSwitchHandler(sender: sender, category: "insect")
    }
    @IBAction func FireSwitch(_ sender: UISwitch) {
        optionSwitchHandler(sender: sender, category: "fire")
    }
    @IBAction func EarthQuakeSwitch(_ sender: UISwitch) {
        optionSwitchHandler(sender: sender, category: "earthquake")
    }
    @IBAction func RadiationSwitch(_ sender: UISwitch) {
        optionSwitchHandler(sender: sender, category: "radiation")
    }
    @IBAction func AirSwitch(_ sender: UISwitch) {
        optionSwitchHandler(sender: sender, category: "air")
    }
    
    func optionSwitchHandler(sender: UISwitch, category: String) {
        if sender.isOn {
            if let customMarker = customMarker {
                customMarker.removeHiddenCategory(category)
                customMarker.showMarkerByCategory(category)
            }
        } else {
            if let customMarker = customMarker {
                customMarker.hideMarkerByCategory(category)
                customMarker.addHiddenCategory(category)
            }
        }
    }
    
    
}

