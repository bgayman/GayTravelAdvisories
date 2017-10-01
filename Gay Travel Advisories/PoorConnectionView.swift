//
//  PoorConnectionView.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/30/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - PoorConnectionView
class PoorConnectionView: UIView {
    
    // MARK: - Properties
    private static  let cornerRadius: CGFloat = 20.0
    private static let spacing: CGFloat = 8.0
    private static let titleText = "Could Not Connect to Server"
    private static let descriptionText = "Functionality may be limited\nand information out of date."
    
    static var height: CGFloat {
        let label = UILabel()
        label.text = PoorConnectionView.titleText
        label.font = UIFont.app_font(style: .body, weight: .black)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        let titleHeight = label.sizeThatFits(CGSize(width: 320.0, height: CGFloat.greatestFiniteMagnitude)).height
        label.text = PoorConnectionView.descriptionText
        label.font = UIFont.app_font(style: .body, weight: .semibold)
        let descriptionHeight = label.sizeThatFits(CGSize(width: 320.0, height: CGFloat.greatestFiniteMagnitude)).height
        
        return PoorConnectionView.cornerRadius * 2 + titleHeight + descriptionHeight + 2 * PoorConnectionView.spacing
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: PoorConnectionView.height)
    }

    private lazy var titleLabel: UILabel = {
        let titleLabel  = UILabel()
        titleLabel.text = PoorConnectionView.titleText
        titleLabel.font = UIFont.app_font(style: .body, weight: .black)
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .app_orange
        titleLabel.textAlignment = .center
        titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 60.0)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)

        return titleLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel  = UILabel()
        descriptionLabel.text = PoorConnectionView.descriptionText
        descriptionLabel.font = UIFont.app_font(style: .body, weight: .semibold)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        
        return descriptionLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.descriptionLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = PoorConnectionView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: PoorConnectionView.cornerRadius).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -PoorConnectionView.cornerRadius - PoorConnectionView.spacing).isActive = true
        
        return stackView
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: nil)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(visualEffectView)
        visualEffectView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        visualEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        return visualEffectView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        isOpaque = false
        visualEffectView.isHidden = false
        stackView.alpha = 0.0
        layer.cornerRadius = PoorConnectionView.cornerRadius
        layer.masksToBounds = true
    }
    
    func showPoorConnection() {
        let effect = UIBlurEffect(style: .dark)
        UIView.animate(withDuration: 0.4) { [unowned self] in
            self.visualEffectView.effect = effect
            self.stackView.alpha = 1.0
        }
    }
    
    func hidePoorConnection() {
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            self.visualEffectView.effect = nil
            self.stackView.alpha = 0.0
        }) { [unowned self](_) in
            self.removeFromSuperview()
        }
    }
    
}
