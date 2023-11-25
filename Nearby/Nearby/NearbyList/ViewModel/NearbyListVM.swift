//
//  NearbyListVM.swift
//  Nearby
//
//  Created by Shubhanshu Tibrewal on 25/11/23.
//

import Foundation
import CoreLocation

protocol NearbyListVMProtocol: AnyObject {
    func fetchNearbylocations(location: CLLocation, completion: @escaping((_ dataModel: [NearbyModel]) -> Void))
    func filterLocations(distance:Int) -> [NearbyModel]
}

class NearbyListVM: NearbyListVMProtocol {
    
    var narbyPlaces: [NearbyModel] = []
    
    func fetchNearbylocations(location: CLLocation, completion: @escaping((_ dataModel: [NearbyModel]) -> Void)) {
        let requestUrl = "https://api.seatgeek.com/2/venues?per_page=10&page=\((narbyPlaces.count / 10) + 1 )&client_id=Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&range=12mi&q=ub"
        
        //// Create the URL to fetch
        guard let url = URL(string: requestUrl) else { fatalError("Invalid URL") }
        //
        //// Create the network manager
        let networkManager = NetworkManager()
        //
        //// Request data from the backend
        networkManager.request(fromURL: url) { (result: Result<PlacesModel, Error>) in
            switch result {
            case .success(let places):
                self.narbyPlaces.append(contentsOf: places.venues)
                completion(places.venues)
            case .failure(let error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
         }

    }
    
    func filterLocations(distance: Int) -> [NearbyModel] {
        //
        return []
    }
    
    
}
