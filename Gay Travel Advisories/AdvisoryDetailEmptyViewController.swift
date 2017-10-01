//
//  AdvisoryDetailEmptyViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit
import CoreMotion
import MobileCoreServices

// MARK: - AdvisoryDetailEmptyViewController
class AdvisoryDetailEmptyViewController: UIViewController {

    // MARK: - Properties
    let motionManager = CMMotionManager()
    
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
    
    var respondsToDeviceGravity = false
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.updateCollisionBounds()
            self.respondsToDeviceGravity = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopDeviceMotionUpdates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = CGPoint(x: view.bounds.midX, y: -imageView.bounds.midY)
        descriptionLabel.center = CGPoint(x: view.bounds.midY, y: -descriptionLabel.bounds.midY)
        
        let y: CGFloat
        if respondsToDeviceGravity {
            updateCollisionBounds()
            y = 25.0 + topLayoutGuide.length
        }
        else {
            y = -view.bounds.midY
        }
        
        let offset = view.bounds.width / CGFloat(pinkTriangleViews.count)
        pinkTriangleViews.enumerated().forEach { (arg) in
            let (index, view) = arg
            view.center = CGPoint(x: CGFloat(index) * offset, y: y)
            dynamicAnimator.updateItem(usingCurrentState: view)
        }
        imageSnapBehavior.snapPoint = view.center
    }

    // MARK: - Setup
    private func setupUI() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = UIColor.app_orange
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            view.addInteraction(UIDropInteraction(delegate: self))
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
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: gravityUpdated)
    }
    
    // MARK: - Helper
    private func updateCollisionBounds() {
        let inset: UIEdgeInsets
        if #available(iOS 11.0, *) {
            inset = self.view.safeAreaInsets
        }
        else {
            inset = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: self.bottomLayoutGuide.length, right: 0)
        }
        self.collision.setTranslatesReferenceBoundsIntoBoundary(with: inset)
    }
    
    // MARK: - Core Motion
    @objc
    private func gravityUpdated(motion: CMDeviceMotion?, error: Error?) {
        
        guard let motion = motion else { return }
        let grav: CMAcceleration = motion.gravity;
        
        let x = CGFloat(grav.x)
        let y = CGFloat(grav.y)
        var p = CGPoint(x: x, y: y)
        
        let orientation = UIApplication.shared.statusBarOrientation;
        
        if orientation == UIInterfaceOrientation.landscapeRight {
            let t = p.x
            p.x = 0 - p.y
            p.y = t
        }
        else if orientation == UIInterfaceOrientation.landscapeLeft {
            let t = p.x
            p.x = p.y
            p.y = 0 - t
        }
        else if orientation == UIInterfaceOrientation.portraitUpsideDown {
            p.x *= -1
            p.y *= -1
        }
        
        let v = CGVector(dx: p.x, dy: 0 - p.y)
        if respondsToDeviceGravity {
            gravity.gravityDirection = v
        }
    }
    
}

@available(iOS 11.0, *)
extension AdvisoryDetailEmptyViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeURL as String])
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        if session.hasItemsConforming(toTypeIdentifiers: [kUTTypeURL as String]) {
            return UIDropProposal(operation: .copy)
        }
        return UIDropProposal(operation: .forbidden)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSURL.self) { [unowned self] (itemProviders) in
            guard let itemProvider = itemProviders.first as? NSURL,
                  let country = Country(shareURL: itemProvider as URL) else { return }
            let advisoryDetailViewController = AdvisoryDetailViewController(country: country)
            let navigationController = UINavigationController(rootViewController: advisoryDetailViewController)
            self.splitViewController?.showDetailViewController(navigationController, sender: nil)
        }
    }
}

