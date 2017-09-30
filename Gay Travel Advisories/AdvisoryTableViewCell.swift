//
//  AdvisoryTableViewCell.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - AdvisoryTableViewCell
class AdvisoryTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet fileprivate weak var textView: UITextView!
    
    // MARK: - Properties
    var attributedText: NSAttributedString? {
        didSet {
            textView.attributedText = attributedText
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.tintColor = UIColor.app_orange
        textView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
}
