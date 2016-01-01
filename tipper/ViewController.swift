//
//  ViewController.swift
//  tipper
//
//  Created by Ahmet Talha Sirdas on 12/31/15.
//  Copyright © 2015 sirdas. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var SerControl: UISegmentedControl!
    @IBOutlet weak var RatControl: UISegmentedControl!

    let setCode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipperLabel: UILabel!
    
    var code: String = ""
    
    func initLocationManager() {
        locationManager.delegate = self
        CLLocationManager.locationServicesEnabled()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first

        print("Found user's location: \(location)")
        CLGeocoder().reverseGeocodeLocation(location!, completionHandler: {(placemarks, error)->Void in
            if error == nil && placemarks!.count > 0 {
               let placemark = placemarks![0] as CLPlacemark
                  self.code = placemark.ISOcountryCode!
            }
        })
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
        self.code = setCode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = ""
        totalLabel.text = ""
        tipperLabel.text = ""
        initLocationManager();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        let amount = NSString(string: amountField.text!).doubleValue
        var tipPer: Double  = 0.0
        var tipRat: Double  = 0.0
        var total: Double = 0.0
        var tip: Double = 0.0

        let a = [0, 1, 2, 3, 4]
        if a[SerControl.selectedSegmentIndex] == 0 {
            switch code {
            case "AT" : tipPer = 0.05
                
            case "CL", "GR", "GT", "HK", "IT", "MO", "ES", "EG" : tipPer = 0.1
                
            default: tipPer = 0
            }
        } else {
            switch code {
            case "AR", "AM", "AU", "AZ", "BS", "BH", "BE", "BO", "BG", "CO", "CZ", "EC", "FI", "FR", "DE", "NL", "HU", "IS", "IN", "ID", "LU", "MG", "NO", "PY", "PH", "PL", "ZA", "SE", "TZ", "UA", "TW", "VE", "AT", "CL", "GR", "GT", "HK", "IT", "MO", "ES", "EG" : tipPer = 0.1
                
            case "BR", "CA", "KY", "IE", "IL", "MX", "PT", "RU", "SA", "UK" : tipPer = 0.15
            
            case "US" : tipPer = 0.2
                
            case "CN" : tipPer = 0.03

            default: tipPer = 0
            }
        }
        
        if a[RatControl.selectedSegmentIndex] == 0 {
            tipRat = 0
        } else if a[RatControl.selectedSegmentIndex] == 1 {
            tipRat = 0.5
        } else if a[RatControl.selectedSegmentIndex] == 2 {
            tipRat = 0.75
        } else if a[RatControl.selectedSegmentIndex] == 3 {
            tipRat = 0.9
        } else {
            tipRat = 1
        }
        
        tip = amount * tipPer * tipRat
        total = amount + tip

        tipLabel.text = "\(tip)"
        totalLabel.text = "\(total)"
        tipLabel.text = String(format: "%.2f", tip)
        totalLabel.text = String(format: "%.2f", total)
        tipperLabel.text = "tipper (\(code))"
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

