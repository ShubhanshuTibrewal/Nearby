//
//  NearbyListViewController.swift
//  Nearby
//
//  Created by Shubhanshu Tibrewal on 25/11/23.
//

import UIKit
import CoreLocation

class NearbyListViewController: UIViewController  {
    @IBOutlet weak var nearbyListView: UITableView!
    @IBOutlet weak var distanceSlider: UISlider!
    
    weak var delegate: NearbyListVMProtocol?
    var locationManager:CLLocationManager?
    var nearbyPlacesList: [NearbyModel]?
    var cuurentLocation : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        nearbyListView.dataSource = self
        nearbyListView.register(UINib.init(nibName: "NearbyPlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "NearbyPlacesTableViewCell")
        determineCurrentLocation()
    }
    
   func determineCurrentLocation() {
       locationManager = CLLocationManager()
       locationManager?.delegate = self
       locationManager?.desiredAccuracy = kCLLocationAccuracyBest
       locationManager?.requestAlwaysAuthorization()
       locationManager?.startUpdatingLocation()
   }
    
}

extension NearbyListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyPlacesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = nearbyPlacesList?[indexPath.row] {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyPlacesTableViewCell") as? NearbyPlacesTableViewCell {
                cell.setupCell(place: model)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (nearbyPlacesList?.count ?? 0) - indexPath.row <= 3 {
            if let center = cuurentLocation {
                delegate?.fetchNearbylocations(location: CLLocation(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude), completion: {[weak self] dataModel in
                    self?.nearbyPlacesList = dataModel
                    self?.nearbyListView.reloadData()
                })
            }
        }
    }
}

extension NearbyListViewController : CLLocationManagerDelegate{
    //MARK:- CLLocationManagerDelegate Methods

 @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
     delegate?.fetchNearbylocations(location: CLLocation(latitude: center.latitude, longitude: center.longitude), completion: {[weak self] dataModel in
         self?.nearbyPlacesList = dataModel
         self?.nearbyListView.reloadData()
     })
    }
 
 @objc func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
        }
    }
}
