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
            travelAdvisoryButton.isHidden = trip?.hasAdvisory == false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        destinationLabel.textColor = .white
        destinationLabel.font = UIFont.app_font(style: .title3, weight: UIFont.Weight.bold)
        destinationLabel.numberOfLines = 0
        
        datesLabel.textColor = .white
        datesLabel.font = UIFont.app_font(style: .caption1, weight: UIFont.Weight.medium)
        datesLabel.numberOfLines = 0
        
        selectionStyle = .none
        
        travelAdvisoryButton.tintColor = .app_pink
    }
    
    @available(iOS 11.0, *)
    override func dragStateDidChange(_ dragState: UITableViewCellDragState) {
        super.dragStateDidChange(dragState)
        switch dragState {
        case .none:
            destinationLabel.textColor = .white
            datesLabel.textColor = .white
        case .lifting:
            destinationLabel.textColor = .black
            datesLabel.textColor = .black
        case .dragging:
            destinationLabel.textColor = .black
            datesLabel.textColor = .black
        }
    }

}
