//
//  AdvisoryDetailEmptyViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - AdvisoryDetailEmptyViewController
class AdvisoryDetailEmptyViewController: UIViewController {

    // MARK: - Properties
    lazy var dynamicAnimator: UIDynamicAnimator = {
        let dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        return dynamicAnimator
    }()
    
    lazy var gravity: UIGravityBehavior = {
        let gravity = UIGravityBehavior(items: pinkTriangleViews as [Any] + [self.imageView, self.descriptionLabel] as! [UIDynamicItem])
        gravity.magnitude = 2.0
        return gravity
    }()
    
    lazy var collision: UICollisionBehavior = {
        let inset = UIEdgeInsets(top: -1000, left: -100, bottom: 0.0, right: -100)
        let collision = UICollisionBehavior(items: pinkTriangleViews as [Any] + [self.imageView, self.descriptionLabel] as! [UIDynamicItem])
        collision.setTranslatesReferenceBoundsIntoBoundary(with: inset)
        return collision
    }()
    
    lazy var imageSnapBehavior: UISnapBehavior = {
        let imageSnapBehavior = UISnapBehavior(item: self.imageView, snapTo: self.view.center)
        imageSnapBehavior.damping = 0.2
        return imageSnapBehavior
    }()
    
    lazy var labelAttachmentBehavior: UIAttachmentBehavior = {
        let labelAttachmentBehavior = UIAttachmentBehavior.limitAttachment(with: self.imageView, offsetFromCenter: .zero, attachedTo: self.descriptionLabel, offsetFromCenter: .zero)
        labelAttachmentBehavior.length = self.imageView.bounds.midY + self.descriptionLabel.bounds.midY + 15.0
        labelAttachmentBehavior.damping = 0.2
        return labelAttachmentBehavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior(items: [self.descriptionLabel, self.imageView])
        itemBehavior.allowsRotation = false
        itemBehavior.angularResistance = 6.0
        itemBehavior.resistance = 2.0
        itemBehavior.density = 4.0
        return itemBehavior
    }()
    
    lazy var pinkTrianglesItemBehavior: UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior(items: pinkTriangleViews)
        itemBehavior.allowsRotation = true
        itemBehavior.elasticity = 0.5
        return itemBehavior
    }()
    
    lazy var pinkTriangleViews: [PinkTriangleView] = {
        let pinkTriangleViews = Array(0 ..< 100).map { _ in PinkTriangleView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)) }
        return pinkTriangleViews
    }()
    
    // MARK: - Outlets
    @IBOutlet fileprivate var imageView: UIImageView!
    @IBOutlet fileprivate var descriptionLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dynamicAnimator.addBehavior(gravity)
        dynamicAnimator.addBehavior(collision)
        dynamicAnimator.addBehavior(imageSnapBehavior)
        dynamicAnimator.addBehavior(labelAttachmentBehavior)
        dynamicAnimator.addBehavior(itemBehavior)
        dynamicAnimator.addBehavior(pinkTrianglesItemBehavior)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.pinkTriangleViews.forEach { $0.alpha = 0.0 }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = CGPoint(x: view.bounds.midX, y: -imageView.bounds.midY)
        descriptionLabel.center = CGPoint(x: view.bounds.midY, y: -descriptionLabel.bounds.midY)
        let offset = view.bounds.width / CGFloat(pinkTriangleViews.count)
        pinkTriangleViews.enumerated().forEach { (arg) in
            let (index, view) = arg
            view.center = CGPoint(x: CGFloat(index) * offset, y: -view.bounds.midY)
        }
    }

    // MARK: - Setup
    private func setupUI() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = UIColor.app_orange
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        view.backgroundColor = UIColor.app_black
        title = "Travel Advisory"
        
        imageView.tintColor = UIColor.app_pink
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.app_font(style: .headline, weight: .bold)
        
        imageView.sizeToFit()
        descriptionLabel.sizeToFit()
    
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        pinkTriangleViews.forEach { view.addSubview($0) }
    }
}

