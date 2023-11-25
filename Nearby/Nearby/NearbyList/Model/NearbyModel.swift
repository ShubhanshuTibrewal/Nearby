//
//  NearbyModel.swift
//  Nearby
//
//  Created by Shubhanshu Tibrewal on 25/11/23.
//

import Foundation

struct PlacesModel : Codable {
    var venues : [NearbyModel]
}

struct NearbyModel : Codable{
    var name: String?
    var url: String?
    var location: location?
    var display_location: String?
}

struct location: Codable {
    var latitude: String?
    var longitude: String?
}
