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

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var customMarker: CustomMarker? = nil
    var mapView: GMSMapView!
    @IBAction func locationTapped(_ sender: Any) {
        gotoPlaces()
    }
    
    @IBOutlet weak var searchText: UITextField!
    
    static var devCount = 0
    static var circleMode = false
    static var lineMode = false
    
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
//        dao.savePath(latitude: [35.892382, 35.891287, 35.887802, 35.885689], longitude: [128.609356, 128.610074, 128.609120, 128.609055], strokeColor: "purple", strokeWidth: 10, category: "river")
        
        customMarker = CustomMarker(mapView: mapView)
        dao.loadOverlays(mapView: mapView, customMarker: customMarker!)
        
        mapView.delegate = self //for func mapView (touch event function)
        
    }
    
    
    static var coordArrayForLineMode = [CLLocationCoordinate2D]()
    static var tempMarkerArrayForLineMode = [GMSMarker]()
    
    //map touch event handler
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        guard ViewController.circleMode || ViewController.lineMode else { //not a dev mode
            return
        }
        
        
        let dao = DAO()
        
        
        if ViewController.circleMode { //dev circle mode is on
            dao.saveCircle(latitude: coordinate.latitude, longitude: coordinate.longitude, radius: 200, fillColor: "orange", strokeColor: "orange", strokeWidth: 1, category: "people")
        }
        
        
        if ViewController.lineMode { //dev line mode is on
            
            //add a marker where you touched
            let marker = GMSMarker(position: coordinate)
            marker.map = mapView
            
            ViewController.coordArrayForLineMode.append(coordinate)
            ViewController.tempMarkerArrayForLineMode.append(marker)
        }
    }
    
    
    @IBOutlet weak var OptionView: UIView!
    
    @IBAction func OptionTitleButton(_ sender: UIButton) {
        if ViewController.devCount <= 2 {
            ViewController.devCount += 1
            
            if(ViewController.devCount == 3) { //when triple times touch on option lable, activate dev mode
                showToast(message: "Dev mod ON")
                DevButton.alpha = 1
                DevButton2.alpha = 1
            }
        } else { //deactivate dev mode when option label is touched 4th times
            ViewController.devCount = 0
            showToast(message: "Dev mode OFF")
            DevButton.alpha = 0
            DevButton2.alpha = 0
        }
    }
    
    @IBOutlet weak var DevButton: UIButton!
    @IBAction func DevButtonHandler(_ sender: UIButton) {
        ViewController.lineMode = false
        
        if ViewController.circleMode {
            ViewController.circleMode = false
            showToast(message: "Circle mode OFF")
        } else {
            ViewController.circleMode = true
            showToast(message: "Circle mode ON")
        }
    }
    
    @IBOutlet weak var DevButton2: UIButton!
    @IBAction func DevButton2Handler(_ sender: UIButton) {
        ViewController.circleMode = false
        
        if ViewController.lineMode {
            
            //split the coordArrayForLineMode to latitudeArr and longitudeArr
            var latitudeArr = [Double](), longitudeArr = [Double]()
            for coord in ViewController.coordArrayForLineMode {
                latitudeArr.append(Double(coord.latitude))
                longitudeArr.append(Double(coord.longitude))
            }
            
            
            //send a path infomations to firebase db
            let dao = DAO()
            dao.savePath(latitude: latitudeArr, longitude: longitudeArr, strokeColor: "blue", strokeWidth: 10, category: "river")
            
            
            //remove all markers
            for m in ViewController.tempMarkerArrayForLineMode {
                m.map = nil
            }
            ViewController.tempMarkerArrayForLineMode.removeAll()
            
            //remove all elements in coordArray
            ViewController.coordArrayForLineMode.removeAll()
            
            
            //line mode OFF
            ViewController.lineMode = false
            showToast(message: "Added a line\nLine mode OFF")
        } else {
            ViewController.lineMode = true
            showToast(message: "Line mode ON")
        }
    }
    
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
    
    @IBOutlet weak var AlphaPercent: UILabel!
    @IBAction func AlphaSlider(_ sender: UISlider) {
        var value = sender.value
        AlphaPercent.text = String(Int(value * 100))
        customMarker?.setAlpha(CGFloat(value))
    }
    
    //hide keyboard when touch background
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    func showToast(message : String) {
            let width_variable:CGFloat = 10
            let toastLabel = UILabel(frame: CGRect(x: width_variable, y: self.view.frame.size.height-100, width: view.frame.size.width-2*width_variable, height: 35))
            // 뷰가 위치할 위치를 지정해준다. 여기서는 아래로부터 100만큼 떨어져있고, 너비는 양쪽에 10만큼 여백을 가지며, 높이는 35로
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 2.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        let location = location.last
        let camera = GMSCameraPosition.camera(withTarget: location!.coordinate, zoom: 15.0)
        self.mapView.camera = camera
        print("\(location!.coordinate.latitude) \(location!.coordinate.longitude)")
    }
    
    func gotoPlaces() {
        searchText.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
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
