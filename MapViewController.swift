//
//  MapViewController.swift
//  FirebaseTutorial
//
//  Created by Shubhashis Roy on 5/20/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var dbRef: FIRDatabaseReference!
    var restaurents = [Restaurent]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
        dbRef = FIRDatabase.database().reference().child("restaurent")
        startObservingDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func back()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startObservingDB ()
    {
        dbRef.observe(FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in
            var newRestaurents = [Restaurent]()
            self.mapView.removeAnnotations(self.restaurents)
            
            for restaurent in snapshot.children {
                let restaurentObject = Restaurent(snapshot: restaurent as! FIRDataSnapshot)
                newRestaurents.append(restaurentObject)
            }
            
            self.restaurents = newRestaurents
            self.mapView.addAnnotations(self.restaurents)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        //let span = MKCoordinateSpanMake(0.2, 0.2)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000)
        
        //let region = MKCoordinateRegion (center:  location,span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation = annotation as? Restaurent
        {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else
            {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "allergyViewController") as! AllergyViewController
        vc.selectedRestaurent = view.annotation as? Restaurent
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
    
    
    //    func centerMapOnLocation(location: CLLocation)
    //    {
    //        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    //        mapView.setRegion(coordinateRegion, animated: true)
    //    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
