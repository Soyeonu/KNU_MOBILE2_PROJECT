//
//  ViewController.swift
//  teamproject
//
//  Created by hmt on 2020/06/09.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {
    
    var customMarker: CustomMarker? = nil
    var mapView : GMSMapView!
    
    @IBOutlet weak var searchText: UITextField!
    @IBAction func locationTapped(_ sender: Any) {
        gotoPlaces()
    }
    
    @IBOutlet weak var touchSetting: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 35.89, longitude: 128.61, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        // 내 위치 버튼 활성화
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
                
        let dao = DAO()
//        dao.saveCircle(latitude: 35.89, longitude: 128.61, radius: 100, fillColor: "red", strokeColor: "red", strokeWidth: 10.0, category: "person")
        dao.savePath(latitude: [35.892382, 35.891287, 35.887802, 35.885689], longitude: [128.609356, 128.610074, 128.609120, 128.609055], strokeColor: "purple", strokeWidth: 5, category: "river")
        
        customMarker = CustomMarker(mapView: mapView)
        dao.loadOverlays(mapView: mapView, customMarker: customMarker!)
        
        // setting button
     //   touchSetting.addTarget(self, action: #selector(goAlert), for: .touchUpInside)
        
        touchSetting.addTarget(self, action:#selector(settingAlert(_:)), for: .touchUpInside)
    }
    
    func gotoPlaces() {
        searchText.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @objc func settingAlert(_ sender: Any) {
        let contentVC = SettingView()
        
        let alert = UIAlertController(title: "설정", message: nil, preferredStyle: .alert)
        
        alert.setValue(contentVC, forKey: "contentViewController")
        
        let okAction = UIAlertAction(title: "저장", style: .default) { (_) in
            print(" sliderValue = \(contentVC.sliderValue)")
            print(" rangeValue = \(contentVC.rangeValue)")
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: false)
        
    }
    
    
    @IBAction func TestButton(_ sender: Any) {
        if let customMarker = customMarker {
            customMarker.hideMarkerByCategory(category: "person")
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        let location = location.last
        let camera = GMSCameraPosition.camera(withTarget: location!.coordinate, zoom: 15.0)
        self.mapView.camera = camera
        print("\(location!.coordinate.latitude) \(location!.coordinate.longitude)")
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Plae name: \(String(describing: place.name))")
        
        dismiss(animated:true, completion: nil)
        
        self.mapView.clear()
        self.searchText.text = place.name
        
        // 검색한 장소 위치로 카메라 옮기기
        let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
        
        self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15.0)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated:true, completion: nil)
    }
    

}
