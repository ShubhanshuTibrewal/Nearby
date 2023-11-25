//
//  NearbyPlacesTableViewCell.swift
//  Nearby
//
//  Created by Shubhanshu Tibrewal on 25/11/23.
//

import UIKit

class NearbyPlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var PlacesTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(place: NearbyModel) {
        PlacesTitle.text = place.name
    }
}
