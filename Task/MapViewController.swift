//
//  MapViewController.swift
//  Task
//
//  Created by Mac on 26/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    var lat = Double()
     var lon = Double()
 
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lat = (UserDefaults.standard.value(forKey: "latitude") as? Double)!
        print(lat)
          lon = (UserDefaults.standard.value(forKey: "longitude") as? Double)!
        print(lon)
       
     
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        let anotation = MKPointAnnotation()
        anotation.coordinate = location
   
        mapView.addAnnotation(anotation)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
