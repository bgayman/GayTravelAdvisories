//
//  CountryPickerTableViewCell.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

class CountryPickerTableViewCell: UITableViewCell {
    
    var name: String? {
        didSet {
            countryLabel.text = name
        }
    }
    
    var searchString: String? {
        didSet {
            countryLabel.attributedText = attributedSearchText
        }
    }
    
    var attributedSearchText: NSAttributedString? {
        guard let name = self.name,
              let searchString = self.searchString else { return nil }
        let attribString = NSMutableAttributedString(string: name)
        let range = (name.lowercased() as NSString).range(of: searchString.lowercased())
        attribString.addAttributes([NSForegroundColorAttributeName: UIColor.app_purple], range: range)
        return attribString
    }

    @IBOutlet fileprivate weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countryLabel.font = UIFont.app_font(style: .body, weight: UIFontWeightMedium)
        countryLabel.textColor = .white
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }
    
}
