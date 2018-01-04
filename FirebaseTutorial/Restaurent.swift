//
//  Restaurent.swift
//  FirebaseTutorial
//
//  Created by Shubhashis Roy on 5/20/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import MapKit
import FirebaseDatabase

class Restaurent: NSObject, MKAnnotation
{
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var foods = [String]()
    var restrictionsOfFood = [String]()
    
    let key: String!
    let itemRef: FIRDatabaseReference?
    
//    init(title: String, subtitle: String, cordinate: CLLocationCoordinate2D)
//    {
//        self.title = title
//        self.subtitle = subtitle
//        self.coordinate = cordinate
//        
//        super.init()
//    }
    
    init (snapshot:FIRDataSnapshot)
    {
        key = snapshot.key
        itemRef = snapshot.ref
        title = ""
        subtitle = ""
        coordinate = CLLocationCoordinate2D()
        
        if let dict = snapshot.value as? NSDictionary
        {
            if let itemTitle = dict["title"] as? String
            {
                title = itemTitle
            }
            else
            {
                title = ""
            }
            
            if let itemSubtitle = dict["subtitle"] as? String
            {
                subtitle = itemSubtitle
            }
            else
            {
                subtitle = ""
            }
            
            let latitude = Double((dict["latitude"] as? Double)!)
            let longitude = Double((dict["longitude"] as? Double)!)
            print("print", title!, subtitle!, latitude, longitude)
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        let snapshotOfFoods = snapshot.childSnapshot(forPath: "foods")
        for food in (snapshotOfFoods.children.allObjects as? [FIRDataSnapshot])!
        {
            self.foods.append(food.key)
            self.restrictionsOfFood.append(food.value! as! String)
        }
        super.init()
    }
}
