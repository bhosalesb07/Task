//
//  ViewController.swift
//  Task
//
//  Created by Mac on 26/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import CoreData
 import MapKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
  
    @IBOutlet weak var tableview: UITableView!
    
    
    @IBOutlet weak var mapview: MKMapView!
    var Latitude: [Double] = [Double]()
    var Members:[Int] = [Int]()
    var Longitude: [Double] = [Double]()
    var Discription:[String] = [String]()
    var Name:[String] = [String]()
    var selectedLon:  [Double] = [Double]()
    var selectedLat: [Double] = [Double]()
  
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.lblmem.text = String(Members[indexPath.row])
         cell.lblname.text = Name[indexPath.row]
         cell.lbldisc.text = Discription[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        if  editingStyle == .delete{
       
           
            Members.remove(at: indexPath.row)
            Discription.remove(at: indexPath.row)
            Name.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
       
            print("Deleted Data ")

        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        selectedLat .append(Latitude[indexPath.row])
        selectedLon .append(Longitude[indexPath.row])
        
     
        let initialLocation = CLLocation(latitude: 51.520000457763672, longitude: -0.2199999988079071)
        let regionRadius: CLLocationDistance = 100
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius, regionRadius)
            mapview.setRegion(coordinateRegion, animated: true)
        }
     
        centerMapOnLocation(location: initialLocation)
        print(selectedLat)
        print(selectedLon)
    
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlstr = "https://api.meetup.com/2/groups?lat=51.509980&lon=-0.133700&page=20&key=1f5718c16a7fb3a5452f45193232"
        parsejson(urlString: urlstr)
        
        tableview.delegate = self
        tableview.dataSource = self
      
    }

    func parsejson(urlString:String)
    {
        enum jsonError:String,Error
        {
            case responseError = "response not found"
            case dataerror = "data not found"
            case conversionEroor = "conversion Failed"
            
        }
        guard let endPoint = URL(string: urlString)
            else
        {
            print("end point not found")
            return
            
        }
        URLSession.shared.dataTask(with: endPoint) { (data , response, error)  in
            do
            {
                guard let response1 = response
                    else
                {
                    throw jsonError.responseError
                }
                print(response1)
                guard let data = data
                    else
                {
                    throw jsonError.dataerror
                }
                
                
             let firstDict:[String:Any] = try
                JSONSerialization.jsonObject(with: data) as! [String:Any]

                
               let resultArray:[[String:Any]] = firstDict["results"] as! [[String:Any]]
                //print(resultArray)
                for item2 in resultArray
                {
                    let member:Int = item2["members"] as! Int
                    self.Members.append(member)
                  
                    let discription:String = item2["description"] as! String
                    self.Discription.append(discription)

                    let latitude:Double = item2["lat"] as! Double
                    self.Latitude.append(latitude)
                   
                    
                    let longitude:Double = item2["lon"] as! Double
                    self.Longitude.append(longitude)
         
                    
                    let name:String = item2["name"] as! String
                    self.Name.append(name)
            
                }
                
                print("Members Are \(self.Members)")
                print("Latitudes Are \(self.Latitude)")
                print("Longitudes Are \(self.Longitude)")
                print("Discriptions Are \(self.Discription)")
                print("Names Are \(self.Name)")
                OperationQueue.main.addOperation
                    {
                    self.tableview.reloadData()
                    self.InsertData()
                       
                    }
            }
            catch let error as jsonError
            {
                print(error.rawValue)
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            }.resume()
     
    }
    
    func InsertData()
    {
       
        let context = delegate.persistentContainer.viewContext;
        
        let MeetingObject:NSObject=NSEntityDescription.insertNewObject(forEntityName:"Meetings", into: context)
      
        for item in Name
        {
            MeetingObject.setValue(item, forKey: "name")
             //  print("Name")
        }
        
        for item1 in Discription
        {
            MeetingObject.setValue(item1, forKey: "discription")
          //  print("Discription")
        }
        let formater = NumberFormatter()
        
            for item3 in Members
            {
         
                MeetingObject.setValue(item3, forKey: "members")
            }
        
        for item4 in Latitude
        {

            MeetingObject.setValue(item4, forKey: "lat")
        }
        
        for item5 in Latitude
        {
    
       
            MeetingObject.setValue(item5, forKey: "lon")
        }
        do
        {
            try context.save()
            
            print("inserted successfully in Core Data")
        }
        catch
        {
            print(error.localizedDescription)
        }
       
    }

}

