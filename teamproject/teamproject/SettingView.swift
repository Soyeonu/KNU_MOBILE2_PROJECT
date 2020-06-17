//
//  SettingView.swift
//  teamproject
//
//  Created by soyeon on 2020/06/17.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit

class SettingView: UIViewController {
    
    let transLabel = UILabel()
    let transSlider = UISlider()
    let rangeLabel = UILabel()
    let rangeSlider = UISlider()
    
    var sliderValue: Float {
        return self.transSlider.value
    }
    
    var rangeValue: Float {
        return self.rangeSlider.value
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transLabel.text = "투명도"
        self.rangeLabel.text = "범위"
        
        self.transSlider.minimumValue = 0
        self.transSlider.maximumValue = 100
        self.rangeSlider.minimumValue = 10  // 최소 범위
        self.rangeSlider.maximumValue = 100 // 최대 범위
        
        self.transLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        self.transSlider.frame = CGRect(x:0, y: 50, width: 170, height: 30)
        self.rangeLabel.frame = CGRect(x: 0, y: 90, width: 50, height: 30)
        self.rangeSlider.frame = CGRect(x:0, y: 140, width: 170, height: 30)
        self.view.addSubview(self.transLabel)
        self.view.addSubview(self.transSlider)
        self.view.addSubview(self.rangeLabel)
        self.view.addSubview(self.rangeSlider)
        
        self.preferredContentSize = CGSize(width: self.transSlider.frame.width, height: 200)
    }


}
