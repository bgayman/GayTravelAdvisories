//
//  TripTableViewCell.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var destinationLabel: UILabel!
    @IBOutlet fileprivate weak var datesLabel: UILabel!
    @IBOutlet weak var travelAdvisoryButton: UIButton!
    
    var trip: Trip? {
        didSet {
            destinationLabel.text = trip?.country.displayName
            datesLabel.text = trip?.dateIntervalString
            travelAdvisoryButton.isHidden = CountriesManager.shared.allAbbreviations.contains(trip?.country.abbreviation.lowercased() ?? "") == false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        destinationLabel.textColor = .white
        destinationLabel.font = UIFont.app_font(style: .title3, weight: UIFontWeightBold)
        destinationLabel.numberOfLines = 0
        
        datesLabel.textColor = .white
        datesLabel.font = UIFont.app_font(style: .caption1, weight: UIFontWeightMedium)
        datesLabel.numberOfLines = 0
        
        travelAdvisoryButton.tintColor = .app_pink
    }

}
