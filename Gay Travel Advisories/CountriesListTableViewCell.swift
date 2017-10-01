//
//  CountriesListTableViewCell.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/30/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

class CountriesListTableViewCell: UITableViewCell {

    @available(iOS 11.0, *)
    override func dragStateDidChange(_ dragState: UITableViewCellDragState) {
        super.dragStateDidChange(dragState)
        switch dragState {
        case .none:
            textLabel?.textColor = .white
        case .lifting:
            textLabel?.textColor = .black
        case .dragging:
            textLabel?.textColor = .black
        }
    }

}
